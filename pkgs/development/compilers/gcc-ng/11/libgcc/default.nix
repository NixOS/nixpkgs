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
    ../custom-threading-model.patch
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
  ''
  # Fix build for Musl (even though musl isn't built yet!)
  #
  # Here's the situation: GCC's default serach patch usual includes an
  # "include-fixed" directory where various hheaders that are non-comformant
  # are overridden with comformant ones. This was probably created for all the
  # old proprietary Unices GNU software had to build on, but also used for
  # glibc for at least limits.h. Musl, however, doesn't hit this problem, and
  # so GCC doesn't bother putting the include-next files on the CLI even though
  # it does ship with them.
  #
  # While libgcc is built prior to libc, it's configure script does check to
  # see if the C pre-processor works, and does so via trying include---you
  # guessed it---limits.h. This works with glibc because it picks up the
  # include-fixed version.  This doesn't work with Musl however because it
  # doesn't pick up any limits.h, and thus thinks the C preprocessor is broken.
  #
  # BTW, we are just discovering this now this now because in a regular
  # monolith build of GCC, the build-time include-fix is *unconditionally*
  # added as an -isystem in CFLAGS_FOR_TARGET, even though it onluy
  # conditionally becomes an installed default. People doing regular MUSL
  # builds therefore haven't hit this issue.
  #
  # Our work-around is to manually add the -isystem ourselves, but only at
  # configure time, by sneaking it in NIX_CLAGS_COMPILE behind the build
  # system's back. While the include-fixed limits.h is probably safe to use, we
  # rather use Musl's own for consistently with how GCC will be used
  # "regularly".
  + lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE_OLD=$NIX_CFLAGS_COMPILE
    NIX_CFLAGS_COMPILE+=' -isystem ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${version}/include-fixed'
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

  # Set the variable back the way it was, see corresponding code in
  # `preConfigure`.
  postConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE=$NIX_CFLAGS_COMPILE_OLD
  '';

  makeFlags = [ "MULTIBUILDTOP:=../" ];

  postInstall = ''
    moveToOutput "lib/gcc/${stdenv.hostPlatform.config}/${version}/include" "$dev"
    mkdir -p "$out/lib" "$dev/include"
    ln -s "$out/lib/gcc/${stdenv.hostPlatform.config}/${version}"/* "$out/lib"
    ln -s "$dev/lib/gcc/${stdenv.hostPlatform.config}/${version}/include"/* "$dev/include/"
  '';
}
