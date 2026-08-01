#!/usr/bin/env bash
set -eu

REPO="https://github.com/xunq-dev/imdead"
DIR="$HOME/deadlocked"

echo "== deadlocked installer =="

# deps
for cmd in git curl cargo; do
    command -v "$cmd" &>/dev/null && continue
    if [ "$cmd" = cargo ]; then
        echo "[*] installing rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        echo "[-] $cmd is required"
        exit 1
    fi
done

# clone / update
if [ -d "$DIR/.git" ]; then
    echo "[*] updating..."
    cd "$DIR"
    git fetch origin rust 2>/dev/null || git fetch origin
    git reset --hard origin/rust
else
    echo "[*] cloning..."
    git clone --branch rust "$REPO" "$DIR"
    cd "$DIR"
fi

# setup (one-time)
echo "[*] running setup..."
bash setup.sh

# build
echo "[*] building..."
cargo build --release

echo "[+] done. run: $DIR/target/release/deadlocked"
