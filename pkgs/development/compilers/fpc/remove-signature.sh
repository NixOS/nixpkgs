source $stdenv/setup

codesign_allocate -r -i "$1" -o "$1"
