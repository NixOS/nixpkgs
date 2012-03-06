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
    if test -n "$langFortran"; then
        langs="$langs,f77"
    fi

    # Perform the build in a different directory.
    mkdir ../build
    cd ../build

    configureScript=../$sourceRoot/configure
    configureFlags="--enable-languages=$langs"
}


postConfigure() {
    if test "$noSysDirs" = "1"; then
        # Patch some of the makefiles to force linking against our own
        # glibc.
        if test -e $NIX_GCC/nix-support/orig-libc; then

            # Figure out what extra flags to pass to the gcc compilers
            # being generated to make sure that they use our glibc.
	    extraFlags="$(cat $NIX_GCC/nix-support/libc-cflags)"
            for i in $(cat $NIX_GCC/nix-support/libc-ldflags) $(cat $NIX_GCC/nix-support/libc-ldflags-before); do
	        extraFlags="$extraFlags -Wl,$i"
            done

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


buildFlags="bootstrap"

genericBuild
