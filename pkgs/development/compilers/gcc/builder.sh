. $stdenv/setup


FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $FIXINC_DUMMY


preConfigure() {
    
    if test "$noSysDirs" = "1"; then
        # Disable the standard include directories.
        cat >> ./gcc/cppdefault.h <<EOF
#undef LOCAL_INCLUDE_DIR
#undef SYSTEM_INCLUDE_DIR
#undef STANDARD_INCLUDE_DIR
EOF
    fi

    # Determine the frontends to build.
    langs="c"
    if test -n "$langCC"; then
        langs="$langs,c++"
    fi
    if test -n "$langF77"; then
        langs="$langs,f77"
    fi

    # Perform the build in a different directory.
    mkdir ../build
    cd ../build

    configureScript=../$sourceRoot/configure
    configureFlags="--enable-languages=$langs"
}

preConfigure=preConfigure


postConfigure() {
    if test "$noSysDirs" = "1"; then
        # Patch some of the makefiles to force linking against our own
        # glibc.
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

        # Patch gcc/Makefile to prevent fixinc.sh from "fixing" system
        # header files from /usr/include.
        mf=gcc/Makefile
        sed \
            -e "s^NATIVE_SYSTEM_HEADER_DIR =\(.*\)^NATIVE_SYSTEM_HEADER_DIR = $FIXINC_DUMMY^" \
            < $mf > $mf.tmp
        mv $mf.tmp $mf
    fi
}

postConfigure=postConfigure


makeFlags="bootstrap"

genericBuild
