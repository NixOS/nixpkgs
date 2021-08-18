{ lib, stdenv, buildPackages
, gcc_src, version
, glibc
, autoreconfHook269, libiberty
}:

stdenv.mkDerivation rec {
  pname = "libgcc";
  inherit version;

  src = gcc_src;

  patches = [
    ./libgcc-custom-threading-model.patch
  ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook269 libiberty ];

  enableParallelBuilding = true;

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  postPatch = ''
    sourceRoot=$(readlink -e "./libgcc")
  '';

  autoreconfFlags = "--install --force --verbose . libgcc";

  preConfigure = ''
    cd "$buildRoot"
  ''

  # Drop in libiberty, as external builds are not expected
  + ''
    (
      mkdir -p build-${stdenv.buildPlatform.config}/libiberty/
      cd build-${stdenv.buildPlatform.config}/libiberty/
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

      export AS_FOR_TARGET=${stdenv.cc}/bin/$AS
      export CC_FOR_TARGET=${stdenv.cc}/bin/$CC
      export CPP_FOR_TARGET=${stdenv.cc}/bin/$CPP
      export LD_FOR_TARGET=${stdenv.cc.bintools}/bin/$LD

      export NIX_CFLAGS_COMPILE_FOR_BUILD+=' -DGENERATOR_FILE=1'

      "$sourceRoot/../gcc/configure" $topLevelConfigureFlags

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
    mkdir -p "$buildRoot/gcc/${stdenv.hostPlatform.config}/libgcc"
    cd "$buildRoot/gcc/${stdenv.hostPlatform.config}/libgcc"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"

    export AS_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$AS_FOR_BUILD
    export CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CC_FOR_BUILD
    export CPP_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CPP_FOR_BUILD
    export CXX_FOR_BUILD=${buildPackages.stdenv.cc}/bin/$CXX_FOR_BUILD
    export LD_FOR_BUILD=${buildPackages.stdenv.cc.bintools}/bin/$LD_FOR_BUILD

    export AS=${stdenv.cc}/bin/$AS
    export CC=${stdenv.cc}/bin/$CC
    export CPP=${stdenv.cc}/bin/$CPP
    export CXX=${stdenv.cc}/bin/$CXX
    export LD=${stdenv.cc.bintools}/bin/$LD

    export AS_FOR_TARGET=${stdenv.cc}/bin/$AS_FOR_TARGET
    export CC_FOR_TARGET=${stdenv.cc}/bin/$CC_FOR_TARGET
    export CPP_FOR_TARGET=${stdenv.cc}/bin/$CPP_FOR_TARGET
    export LD_FOR_TARGET=${stdenv.cc.bintools}/bin/$LD_FOR_TARGET
  '';

  topLevelConfigureFlags = [
    "--build=${stdenv.buildPlatform.config}"
    "--host=${stdenv.buildPlatform.config}"
    "--target=${stdenv.hostPlatform.config}"

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
  ] ++ lib.optional (stdenv.hostPlatform.libc == "glibc")
       "--with-glibc-version=${glibc.version}";

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--disable-dependency-tracking"
    "--with-threads=single"
    # $CC cannot link binaries, let alone run then
    "cross_compiling=true"
    # Do not have dynamic linker without libc
    "--enable-static"
    "--disable-shared"
  ];

  makeFlags = [ "MULTIBUILDTOP:=../" ];

  postInstall = ''
    moveToOutput "lib/gcc/${stdenv.hostPlatform.config}/${version}/include" "$dev"
    mkdir -p "$out/lib" "$dev/include"
    ln -s "$out/lib/gcc/${stdenv.hostPlatform.config}/${version}"/* "$out/lib"
    ln -s "$dev/lib/gcc/${stdenv.hostPlatform.config}/${version}/include"/* "$dev/include/"
  '';
}
