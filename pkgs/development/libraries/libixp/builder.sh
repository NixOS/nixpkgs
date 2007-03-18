source $stdenv/setup
 
## oh, this is ugly. It would be way better to fix the Makefile instead
postUnpack() {
cd $sourceRoot

cat > config.mk <<END
VERSION = 0.3
PREFIX=
MANPREFIX=/share/man

INCS = -I.
LIBS = -L. -lc

LDFLAGS = \${LIBS}

CFLAGS = -g \${INCS} -DVERSION=\"\${VERSION}\"
SOFLAGS = -fPIC -shared

AR = ar cr
RANLIB = ranlib

END

echo -e "PREFIX=\nDESTDIR=${out}" >> config.mk

cd ..
}
 
postUnpack=postUnpack

genericBuild
