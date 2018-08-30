{ stdenvNoLibs, buildPackages, buildPlatform, hostPlatform
, gcc, glibc
, libiberty
}:

stdenvNoLibs.mkDerivation rec {
  name = "libgcc-${version}";
  inherit (gcc.cc) src version;

  outputs = [ "out" "dev" ];

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ libiberty ];

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  postPatch = ''
    sourceRoot=$(readlink -e "./libgcc")
  '';

  preConfigure = ''
    cd "$buildRoot"
  ''

  # Drop in libiberty, as external builds are not expected
  + ''
    (
      mkdir -p build-${buildPlatform.config}/libiberty/
      cd build-${buildPlatform.config}/libiberty/
      ln -s ${buildPackages.libiberty}/lib/libiberty.a ./
    )
  ''
  # A few misc bits of gcc need to be built.
  #
  #  - We "shift" the tools over to fake platforms perspective from the previous
  #    stage.
  #
  #  - We define GENERATOR_FILE so nothing bothers looking for GNU GMP.
  #
  #  - We remove the `libgcc.mvar` deps so that the bootstrap xgcc isn't built.
  + ''
    mkdir -p "$buildRoot/gcc"
    cd "$buildRoot/gcc"
    (
      export AS_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$AS_FOR_BUILD
      export CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CC_FOR_BUILD
      export CPP_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CPP_FOR_BUILD
      export CXX_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CXX_FOR_BUILD
      export LD_FOR_BUILD=${buildPackages.stdenv.cc.bintools}/bin/$LD_FOR_BUILD

      export AS=$AS_FOR_BUILD
      export CC=$CC_FOR_BUILD
      export CPP=$CPP_FOR_BUILD
      export CXX=$CXX_FOR_BUILD
      export LD=$LD_FOR_BUILD

      export AS_FOR_TARGET=${stdenvNoLibs.cc}/bin/$AS
      export CC_FOR_TARGET=${stdenvNoLibs.cc}/bin/$CC
      export CPP_FOR_TARGET=${stdenvNoLibs.cc}/bin/$CPP
      export LD_FOR_TARGET=${stdenvNoLibs.cc.bintools}/bin/$LD

      export NIX_BUILD_CFLAGS_COMPILE+=' -DGENERATOR_FILE=1'

      "$sourceRoot/../gcc/configure" $gccConfigureFlags

      sed -e 's,libgcc.mvars:.*$,libgcc.mvars:,' -i Makefile

      make \
        config.h \
        libgcc.mvars \
        tconfig.h \
        tm.h \
        options.h \
        insn-constants.h \
        insn-modes.h \
        gcov-iov.h
    )
    mkdir -p "$buildRoot/gcc/include"
  ''
  # Preparing to configure + build libgcc itself
  + ''
    mkdir -p "$buildRoot/gcc/${hostPlatform.config}/libgcc"
    cd "$buildRoot/gcc/${hostPlatform.config}/libgcc"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"

    export AS_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$AS_FOR_BUILD
    export CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CC_FOR_BUILD
    export CPP_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CPP_FOR_BUILD
    export CXX_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CXX_FOR_BUILD
    export LD_FOR_BUILD=${buildPackages.stdenv.cc.bintools}/bin/$LD_FOR_BUILD

    export AS=${stdenvNoLibs.cc}/bin/$AS
    export CC=${stdenvNoLibs.cc}/bin/$CC
    export CPP=${stdenvNoLibs.cc}/bin/$CPP
    export CXX=${stdenvNoLibs.cc}/bin/$CXX
    export LD=${stdenvNoLibs.cc.bintools}/bin/$LD

    export AS_FOR_TARGET=${stdenvNoLibs.cc}/bin/$AS_FOR_TARGET
    export CC_FOR_TARGET=${stdenvNoLibs.cc}/bin/$CC_FOR_TARGET
    export CPP_FOR_TARGET=${stdenvNoLibs.cc}/bin/$CPP_FOR_TARGET
    export LD_FOR_TARGET=${stdenvNoLibs.cc.bintools}/bin/$LD_FOR_TARGET
  '';

  gccConfigureFlags = [
    "--build=${buildPlatform.config}"
    "--host=${buildPlatform.config}"
    "--target=${hostPlatform.config}"

    "--disable-bootstrap"
    "--disable-multilib" "--with-multilib-list="
    "--enable-languages=c"

    "--disable-fixincludes"
    "--disable-intl"
    "--disable-lto"
    "--disable-libatomic"
    "--disable-libbacktrace"
    "--disable-libcpp"
    "--disable-libssp"
    "--disable-libquadmath"
    "--disable-libgomp"
    "--disable-libvtv"
    "--disable-vtable-verify"

    "--with-system-zlib"
  ] ++ stdenvNoLibs.lib.optional (hostPlatform.libc == "glibc")
       "--with-glibc-version=${glibc.version}";

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--disable-dependency-tracking"
    # $CC cannot link binaries, let alone run then
    "cross_compiling=true"
    # Do not have dynamic linker without libc
    "--enable-static"
    "--disable-shared"
  ];

  makeFlags = [ "MULTIBUILDTOP:=../" ];

  postInstall = ''
    moveToOutput "lib/gcc/${hostPlatform.config}/${version}/include" "$dev"
    mkdir -p "$out/lib" "$dev/include"
    ln -s "$out/lib/gcc/${hostPlatform.config}/${version}"/* "$out/lib"
    ln -s "$dev/lib/gcc/${hostPlatform.config}/${version}/include"/* "$dev/include/"
  '';
}
