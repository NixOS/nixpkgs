. $stdenv/setup


FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $FIXINC_DUMMY


preConfigure() {
    
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
        if test -e $NIX_GCC/nix-support/orig-glibc; then
            glibc=$(cat $NIX_GCC/nix-support/orig-glibc)
            # Ugh.  Copied from gcc-wrapper/builder.sh.  We can't just
            # source in $NIX_GCC/nix-support/add-flags, since that
            # would cause *this* GCC to be linked against the
            # *previous* GCC.  Need some more modularity there.
            extraFlags="-Wl,-s -B$glibc/lib -isystem $glibc/include \
                -L$glibc/lib -Wl,-dynamic-linker -Wl,$glibc/lib/ld-linux.so.2"

            # Oh, what a hack.  I should be shot for this.
            # In stage 1, we should link against the previous GCC, but
            # not afterwards.  Otherwise we retain a dependency.
            # However, ld-wrapper, which adds the linker flags for the
            # previous GCC, is also used in stage 2/3.  We can prevent
            # it from adding them by NIX_GLIBC_FLAGS_SET, but then
            # gcc-wrapper will also not add them, thereby causing
            # stage 1 to fail.  So we use a trick to only set the
            # flags in gcc-wrapper.
            hook=$(pwd)/ld-wrapper-hook
            echo "NIX_GLIBC_FLAGS_SET=1" > $hook
            export NIX_LD_WRAPPER_START_HOOK=$hook
        fi

#        mf=Makefile
#        sed \
#            -e "s^FLAGS_FOR_TARGET =\(.*\)^FLAGS_FOR_TARGET = \1 $extraFlags^" \
#            < $mf > $mf.tmp
#        mv $mf.tmp $mf

#        mf=gcc/Makefile
#        sed \
#            -e "s^X_CFLAGS =\(.*\)^X_CFLAGS = \1 $extraFlags^" \
#            < $mf > $mf.tmp
#        mv $mf.tmp $mf

        # Patch gcc/Makefile to prevent fixinc.sh from "fixing" system
        # header files from /usr/include.
#        mf=gcc/Makefile
#        sed \
#            -e "s^NATIVE_SYSTEM_HEADER_DIR =\(.*\)^NATIVE_SYSTEM_HEADER_DIR = $FIXINC_DUMMY^" \
#            < $mf > $mf.tmp
#        mv $mf.tmp $mf
    fi
}

postConfigure=postConfigure


makeFlags="bootstrap"

genericBuild
