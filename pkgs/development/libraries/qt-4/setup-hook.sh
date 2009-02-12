export QTDIR=@out@

if [ -n $qt4BadIncludes ]; then
    for d in @out@/include/*; do
	export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$d";
    done;
fi
