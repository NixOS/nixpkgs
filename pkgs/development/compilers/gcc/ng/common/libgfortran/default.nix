{
  lib,
  stdenv,
  gfortran,
  gcc_meta,
  release_version,
  version,
  getVersionFile,
  monorepoSrc ? null,
  autoreconfHook269,
  libiberty,
  buildPackages,
  libgcc,
  libbacktrace,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libgfortran";
  inherit version;

  src = monorepoSrc;

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook269
    libiberty
    gfortran
  ];

  patches = [
    (getVersionFile "libgfortran/force-regular-dirs.patch")
  ];

  autoreconfFlags = "--install --force --verbose . libgfortran";

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  postPatch = ''
    sourceRoot=$(readlink -e "./libgfortran")
  '';

  enableParallelBuilding = true;

  preConfigure = ''
    cd "$buildRoot"

    mkdir -p build-${stdenv.buildPlatform.config}/libiberty/
    cd build-${stdenv.buildPlatform.config}/libiberty/
    ln -s ${libiberty}/lib/libiberty.a ./

    mkdir -p "$buildRoot/gcc"
    cd "$buildRoot/gcc"

    (
    export AS_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$AS_FOR_BUILD"}
    export CC_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$CC_FOR_BUILD"}
    export CPP_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$CPP_FOR_BUILD"}
    export CXX_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$CXX_FOR_BUILD"}
    export LD_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc.bintools "$LD_FOR_BUILD"}

    export AS=$AS_FOR_BUILD
    export CC=$CC_FOR_BUILD
    export CPP=$CPP_FOR_BUILD
    export CXX=$CXX_FOR_BUILD
    export LD=$LD_FOR_BUILD

    export AS_FOR_TARGET=${lib.getExe' stdenv.cc "$AS"}
    export CC_FOR_TARGET=${lib.getExe' stdenv.cc "$CC"}
    export CPP_FOR_TARGET=${lib.getExe' stdenv.cc "$CPP"}
    export LD_FOR_TARGET=${lib.getExe' stdenv.cc.bintools "$LD"}

    export NIX_CFLAGS_COMPILE_FOR_BUILD+=' -DGENERATOR_FILE=1'

    "$sourceRoot/../gcc/configure" $topLevelConfigureFlags

    make \
      config.h
    )
    mkdir -p "$buildRoot/gcc/include"

    mkdir -p "$buildRoot/gcc/libbacktrace/.libs"
    cp ${libbacktrace}/lib/libbacktrace.a "$buildRoot/gcc/libbacktrace/.libs/libbacktrace.a"
    cp -r ${libbacktrace}/lib/*.la "$buildRoot/gcc/libbacktrace"
    cp -r ${libbacktrace.dev}/include/*.h "$buildRoot/gcc/libbacktrace"

    mkdir -p "$buildRoot/gcc/libgcc"
    ln -s "${libgcc.dev}/include/gthr-default.h" "$buildRoot/gcc/libgcc"

    mkdir -p "$buildRoot/gcc/${stdenv.hostPlatform.config}/libgfortran"
    ln -s "$buildRoot/gcc/libbacktrace" "$buildRoot/gcc/${stdenv.buildPlatform.config}/libbacktrace"
    ln -s "$buildRoot/gcc/libgcc" "$buildRoot/gcc/${stdenv.buildPlatform.config}/libgcc"
    cd "$buildRoot/gcc/${stdenv.hostPlatform.config}/libgfortran"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"

    export AS_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$AS_FOR_BUILD"}
    export CC_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$CC_FOR_BUILD"}
    export CPP_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$CPP_FOR_BUILD"}
    export CXX_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$CXX_FOR_BUILD"}
    export LD_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc.bintools "$LD_FOR_BUILD"}

    export AS=${lib.getExe' stdenv.cc "$AS"}
    export CC=${lib.getExe' stdenv.cc "$CC"}
    export CPP=${lib.getExe' stdenv.cc "$CPP"}
    export CXX=${lib.getExe' stdenv.cc "$CXX"}
    export LD=${lib.getExe' stdenv.cc.bintools "$LD"}

    export AS_FOR_TARGET=${lib.getExe' stdenv.cc "$AS_FOR_TARGET"}
    export CC_FOR_TARGET=${lib.getExe' stdenv.cc "$CC_FOR_TARGET"}
    export CPP_FOR_TARGET=${lib.getExe' stdenv.cc "$CPP_FOR_TARGET"}
    export LD_FOR_TARGET=${lib.getExe' stdenv.cc.bintools "$LD_FOR_TARGET"}
  ''
  + lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE_OLD=$NIX_CFLAGS_COMPILE
    NIX_CFLAGS_COMPILE+=' -isystem ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${version}/include-fixed'
  '';

  topLevelConfigureFlags = [
    "--build=${stdenv.buildPlatform.config}"
    "--host=${stdenv.buildPlatform.config}"
    "--target=${stdenv.hostPlatform.config}"

    "--disable-bootstrap"
    "--disable-multilib"
    "--with-multilib-list="
    "--enable-languages=fortran"

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
  ]
  ++
    lib.optional (stdenv.hostPlatform.libc == "glibc")
      # Cheat and use previous stage's glibc to avoid infinite recursion. As
      # of GCC 11, libgcc only cares if the version is greater than 2.19,
      # which is quite ancient, so this little lie should be fine.
      "--with-glibc-version=${buildPackages.glibc.version}";

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--disable-dependency-tracking"
    "gcc_cv_target_thread_file=single"
    # $CC cannot link binaries, let alone run then
    "cross_compiling=true"
    "--with-toolexeclibdir=${builtins.placeholder "dev"}/lib"
  ];

  # Set the variable back the way it was, see corresponding code in
  # `preConfigure`.
  postConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE=$NIX_CFLAGS_COMPILE_OLD
  '';

  makeFlags = [ "MULTIBUILDTOP:=../" ];

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
