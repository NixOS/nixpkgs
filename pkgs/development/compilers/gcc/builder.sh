#! /bin/sh -e

buildinputs="$binutils"
. $stdenv/setup

tar xvfj $src

if test "$enforcePurity" = "1"; then
    # Disable the standard include directories.
    cd gcc-*
    cat >> ./gcc/cppdefault.h <<EOF
#undef LOCAL_INCLUDE_DIR
#undef SYSTEM_INCLUDE_DIR
#undef STANDARD_INCLUDE_DIR
EOF
    cd ..
fi

langs="c"
if test -n "$langCC"; then
    langs="$langs,c++"
fi
if test -n "$langF77"; then
    langs="$langs,f77"
fi

# Configure.
mkdir build
cd build
../gcc-*/configure --prefix=$out --enable-languages="$langs"

if test "$enforcePurity" = "1"; then
    # Patch some of the makefiles to force linking against our own glibc.
    . $NIX_GCC/nix-support/add-flags # add glibc/gcc flags
    extraflags="-Wl,-s $NIX_CFLAGS_COMPILE $NIX_CFLAGS_LINK"
    for i in $NIX_LDFLAGS; do
        extraflags="$extraflags -Wl,$i"
    done

    mf=Makefile
    sed \
        -e "s^FLAGS_FOR_TARGET =\(.*\)^FLAGS_FOR_TARGET = \1 $extraflags^" \
        < $mf > $mf.tmp
    mv $mf.tmp $mf

    mf=gcc/Makefile
    sed \
        -e "s^X_CFLAGS =\(.*\)^X_CFLAGS = \1 $extraflags^" \
        < $mf > $mf.tmp
    mv $mf.tmp $mf

    # Patch gcc/Makefile to prevent fixinc.sh from "fixing" system header files
    # from /usr/include.
    mf=gcc/Makefile
    sed \
        -e "s^NATIVE_SYSTEM_HEADER_DIR =\(.*\)^NATIVE_SYSTEM_HEADER_DIR = /fixinc-disabled^" \
        < $mf > $mf.tmp
    mv $mf.tmp $mf
fi

# Build and install.
make bootstrap
make install

find $out -name "*.a" -exec strip -S {} \;
