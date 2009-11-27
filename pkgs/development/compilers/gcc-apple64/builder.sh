source $stdenv/setup


export NIX_FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $NIX_FIXINC_DUMMY


# libstdc++ needs this; otherwise it will use /lib/cpp, which is a Bad
# Thing.
export CPP="gcc -E"


if test "$noSysDirs" = "1"; then

    # Figure out what extra flags to pass to the gcc compilers being
    # generated to make sure that they use our glibc.
    if test -e $NIX_GCC/nix-support/orig-glibc; then
        glibc=$(cat $NIX_GCC/nix-support/orig-glibc)

        # Ugh.  Copied from gcc-wrapper/builder.sh.  We can't just
        # source in $NIX_GCC/nix-support/add-flags, since that would
        # cause *this* GCC to be linked against the *previous* GCC.
        # Need some more modularity there.
        extraCFlags="-B$glibc/lib -isystem $glibc/include"
        extraLDFlags="-B$glibc/lib -L$glibc/lib -Wl,-s \
          -Wl,-dynamic-linker,$glibc/lib/ld-linux.so.2"

        # Oh, what a hack.  I should be shot for this.  In stage 1, we
        # should link against the previous GCC, but not afterwards.
        # Otherwise we retain a dependency.  However, ld-wrapper,
        # which adds the linker flags for the previous GCC, is also
        # used in stage 2/3.  We can prevent it from adding them by
        # NIX_GLIBC_FLAGS_SET, but then gcc-wrapper will also not add
        # them, thereby causing stage 1 to fail.  So we use a trick to
        # only set the flags in gcc-wrapper.
        hook=$(pwd)/ld-wrapper-hook
        echo "NIX_GLIBC_FLAGS_SET=1" > $hook
        export NIX_LD_WRAPPER_START_HOOK=$hook

        # Use *real* header files, otherwise a limits.h is generated
        # that does not include Glibc's limits.h (notably missing
        # SSIZE_MAX, which breaks the build).
        export NIX_FIXINC_DUMMY=$glibc/include
    fi

    export NIX_EXTRA_CFLAGS=$extraCFlags
    export NIX_EXTRA_LDFLAGS=$extraLDFlags
    export CFLAGS=$extraCFlags
    export CXXFLAGS=$extraCFlags
    export LDFLAGS=$extraLDFlags
fi


preConfigure() {
    
    # Determine the frontends to build.
    langs="c"
    if test -n "$langCC"; then
        langs="$langs,c++"
    fi
    if test -n "$langF77"; then
        langs="$langs,f95"
    fi

    # Perform the build in a different directory.
    mkdir ../build
    cd ../build

    configureScript=../$sourceRoot/configure
    configureFlags="--enable-languages=$langs --disable-libstdcxx-pch --disable-libstdcxx-debug --disable-multilib --with-gxx-include-dir=${STDCXX_INCDIR}"
}


postInstall() {
    # Remove precompiled headers for now.  They are very big and
    # probably not very useful yet.
    find $out/include -name "*.gch" -exec rm -rf {} \; -prune

    # Remove `fixincl' to prevent a retained dependency on the
    # previous gcc.
    rm -rf $out/libexec/gcc/*/*/install-tools
}

postUnpack() {
  mv $libstdcxx/libstdcxx $sourceRoot/
}

STDCXX_INCDIR="$out/include/c++/4.2.1"

genericBuild


echo '-------------------------------------------------------------------------------------------------------------------------'
echo 'libstdcxx-16'
echo '-------------------------------------------------------------------------------------------------------------------------'

cd ..
pwd

preConfigure() {
    # Perform the build in a different directory.
    mkdir ../build_libstdcxx
    cd ../build_libstdcxx

    ln -s ../build/gcc gcc
    
    configureScript=../$sourceRoot/libstdcxx/configure
    configureFlags="--disable-libstdcxx-pch --disable-libstdcxx-debug --disable-multilib --with-gxx-include-dir=${STDCXX_INCDIR}"
}

unpackPhase () {
  echo '-'
}

postInstall() {
  echo '-'
  echo "cp -v ${STDCXX_INCDIR}/*/bits/* ${STDCXX_INCDIR}/bits/"
  cp -v ${STDCXX_INCDIR}/*/bits/* ${STDCXX_INCDIR}/bits/
}

patchPhase() {
  echo '-'
}

genericBuild
