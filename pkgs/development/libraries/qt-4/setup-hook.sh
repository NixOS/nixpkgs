export QTDIR=@out@

for d in @out@/include/*; do
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$d"
done
