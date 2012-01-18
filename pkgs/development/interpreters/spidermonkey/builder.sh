source $stdenv/setup

set -e
set -x

tar zxf $src
cd js/src


# Extend Makefile to dump some of its variables we want to know.
cat >> Makefile.ref <<EOF
printlibraries :
	@echo \$(LIBRARY) \$(SHARED_LIBRARY) > LIBRARIES

printprograms :
	@echo \$(PROGRAM) > PROGRAMS
EOF

MAKE="make -f Makefile.ref"

$MAKE printlibraries
$MAKE printprograms
$MAKE

mkdir -p $out
mkdir -p $out/bin
mkdir -p $out/lib

# Install the binaries that have been created.
install $(cat PROGRAMS) $out/bin
install $(cat LIBRARIES) $out/lib
