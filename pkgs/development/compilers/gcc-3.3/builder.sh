source $stdenv/setup


FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $FIXINC_DUMMY


# libstdc++ needs this; otherwise it will use /lib/cpp, which is a Bad
# Thing.
export CPP="gcc -E"


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
        if test -e $NIX_GCC/nix-support/orig-libc; then
            glibc=$(cat $NIX_GCC/nix-support/orig-libc)
            # Ugh.  Copied from gcc-wrapper/builder.sh.  We can't just
            # source in $NIX_GCC/nix-support/add-flags, since that
            # would cause *this* GCC to be linked against the
            # *previous* GCC.  Need some more modularity there.
            extraFlags="-Wl,-s -B$glibc/lib -isystem $glibc/include \
                -L$glibc/lib -Wl,-dynamic-linker -Wl,$glibc/lib/ld-linux.so.2"

            # Use *real* header files, otherwise a limits.h is generated
            # that does not include Glibc's limits.h (notably missing
            # SSIZE_MAX, which breaks the build).
            export FIXINC_DUMMY=$(cat $NIX_GCC/nix-support/orig-libc)/include
        fi

        mf=Makefile
        sed \
            -e "s^FLAGS_FOR_TARGET =\(.*\)^FLAGS_FOR_TARGET = \1 $extraFlags^" \
            < $mf > $mf.tmp
        mv $mf.tmp $mf

        mf=gcc/Makefile
        sed \
            -e "s^X_CFLAGS =\(.*\)^X_CFLAGS = \1 $extraFlags^" \
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
