{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  # Most packages depending on openblas expect integer width to match
  # pointer width, but some expect to use 32-bit integers always
  # (for compatibility with reference BLAS).
  blas64 ? null,
  # Multi-threaded applications must not call a threaded OpenBLAS
  # (the only exception is when an application uses OpenMP as its
  # *only* form of multi-threading). See
  #     https://github.com/OpenMathLib/OpenBLAS/wiki/Faq/4bded95e8dc8aadc70ce65267d1093ca7bdefc4c#multi-threaded
  #     https://github.com/OpenMathLib/OpenBLAS/issues/2543
  # This flag builds a single-threaded OpenBLAS using the flags
  # stated in thre.
  singleThreaded ? false,
  buildPackages,
  # Select a specific optimization target (other than the default)
  # See https://github.com/OpenMathLib/OpenBLAS/blob/develop/TargetList.txt
  target ? null,
  # Select whether DYNAMIC_ARCH is enabled or not.
  dynamicArch ? null,
  # enable AVX512 optimized kernels.
  # These kernels have been a source of trouble in the past.
  # Use with caution.
  enableAVX512 ? false,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,

  # for passthru.tests
  ceres-solver,
  flint,
  giac,
  octave,
  opencv,
  python3,
  R,
  openmp ? null,
  testers,
}:

let
  blas64_ = blas64;
in

let
  setTarget = x: if target == null then x else target;
  setDynamicArch = x: if dynamicArch == null then x else dynamicArch;

  # To add support for a new platform, add an element to this set.
  configs = {
    armv6l-linux = {
      BINARY = 32;
      TARGET = setTarget "ARMV6";
      DYNAMIC_ARCH = setDynamicArch false;
      USE_OPENMP = true;
    };

    armv7l-linux = {
      BINARY = 32;
      TARGET = setTarget "ARMV7";
      DYNAMIC_ARCH = setDynamicArch false;
      USE_OPENMP = true;
    };

    aarch64-darwin = {
      BINARY = 64;
      TARGET = setTarget "VORTEX";
      DYNAMIC_ARCH = setDynamicArch true;
      USE_OPENMP = false;
      MACOSX_DEPLOYMENT_TARGET = "11.0";
    };

    aarch64-linux = {
      BINARY = 64;
      TARGET = setTarget "ARMV8";
      DYNAMIC_ARCH = setDynamicArch true;
      USE_OPENMP = true;
    };

    i686-linux = {
      BINARY = 32;
      TARGET = setTarget "P2";
      DYNAMIC_ARCH = setDynamicArch true;
      USE_OPENMP = true;
    };

    x86_64-darwin = {
      BINARY = 64;
      TARGET = setTarget "ATHLON";
      DYNAMIC_ARCH = setDynamicArch true;
      NO_AVX512 = !enableAVX512;
      USE_OPENMP = false;
      MACOSX_DEPLOYMENT_TARGET = "10.7";
    };

    x86_64-linux = {
      BINARY = 64;
      TARGET = setTarget "ATHLON";
      DYNAMIC_ARCH = setDynamicArch true;
      NO_AVX512 = !enableAVX512;
      USE_OPENMP = !stdenv.hostPlatform.isMusl;
    };

    x86_64-windows = {
      BINARY = 64;
      TARGET = setTarget "ATHLON";
      DYNAMIC_ARCH = setDynamicArch true;
      NO_AVX512 = !enableAVX512;
      USE_OPENMP = false;
    };

    powerpc64-linux = {
      BINARY = 64;
      TARGET = setTarget "POWER4";
      DYNAMIC_ARCH = setDynamicArch false;
      USE_OPENMP = !stdenv.hostPlatform.isMusl;
    };

    powerpc64le-linux = {
      BINARY = 64;
      TARGET = setTarget "POWER5";
      DYNAMIC_ARCH = setDynamicArch true;
      USE_OPENMP = !stdenv.hostPlatform.isMusl;
    };

    riscv64-linux = {
      BINARY = 64;
      TARGET = setTarget "RISCV64_GENERIC";
      DYNAMIC_ARCH = setDynamicArch false;
      USE_OPENMP = true;
    };

    loongarch64-linux = {
      TARGET = setTarget "LA64_GENERIC";
      DYNAMIC_ARCH = setDynamicArch false;
      USE_OPENMP = true;
    };

    s390x-linux = {
      BINARY = 64;
      TARGET = setTarget "ZARCH_GENERIC";
      DYNAMIC_ARCH = setDynamicArch true;
      USE_OPENMP = true;
    };

    x86_64-freebsd = {
      BINARY = 64;
      TARGET = setTarget "ATHLON";
      DYNAMIC_ARCH = setDynamicArch true;
      NO_AVX512 = !enableAVX512;
      USE_OPENMP = true;
    };
  };
in

let
  config =
    configs.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in

let
  blas64 = if blas64_ != null then blas64_ else lib.hasPrefix "x86_64" stdenv.hostPlatform.system;

  shlibExt = stdenv.hostPlatform.extensions.sharedLibrary;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "openblas";
  version = "0.3.32";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "OpenMathLib";
    repo = "OpenBLAS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D0Wu5Ew72aTqSjj970yOfAwPg1T4Qm6zmpaGlQ/5Q1k=";
  };

  patches = [
    # Fix broken cmake config file path when CMAKE_INSTALL_INCLUDEDIR is an absolute path
    # Add NO_SUFFIX64 option to suppress _64 library name suffix
    # INCLUDEDIR already fixed in upstream HEAD & significant refactor
    # to config gen so not PRing changes
    ./cmake-include-fixes.patch
    # Fix build on LoongArch (error: '_Float16' is not supported on this target)
    (fetchpatch {
      url = "https://github.com/OpenMathLib/OpenBLAS/commit/7086a1b075ca317e12cfe79d40a32ad342a30496.patch";
      hash = "sha256-pA3HK2f2MJr/+h/uale7edIYk/KH194EscYFcsujPXY=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # Backport https://github.com/OpenMathLib/OpenBLAS/pull/5710
    # Work around miscompilation of the ARM64 non-SVE DDOT kernel
    (fetchpatch {
      url = "https://github.com/OpenMathLib/OpenBLAS/commit/e3ce4623c299068bbd47c35ee87aab334bac73b1.patch";
      hash = "sha256-j0zIJjNiAdIVPgdxB+pXiOrOtedDu6Yq+dgaJ/wCquk=";
    })
  ];

  inherit blas64;

  # Some hardening features are disabled due to sporadic failures in
  # OpenBLAS-based programs. The problem may not be with OpenBLAS itself, but
  # with how these flags interact with hardening measures used downstream.
  # In either case, OpenBLAS must only be used by trusted code--it is
  # inherently unsuitable for security-conscious applications--so there should
  # be no objection to disabling these hardening measures.
  hardeningDisable = [
    # don't modify or move the stack
    "stackprotector"
    "pic"
    # don't alter index arithmetic
    "strictoverflow"
    # don't interfere with dynamic target detection
    "relro"
    "bindnow"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # "__builtin_clear_padding not supported for variable length aggregates"
    # in aarch64-specific code
    "trivialautovarinit"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optional (stdenv.cc.isClang && config.USE_OPENMP) openmp;

  depsBuildBuild = [
    buildPackages.gfortran
    buildPackages.stdenv.cc
  ];

  cmakeFlags = [
    (lib.cmakeFeature "TARGET" config.TARGET)
    (lib.cmakeBool "DYNAMIC_ARCH" config.DYNAMIC_ARCH)
    (lib.cmakeBool "USE_OPENMP" config.USE_OPENMP)
    (lib.cmakeFeature "NUM_THREADS" "64")
    (lib.cmakeBool "INTERFACE64" blas64)
    # Don't suffix library/pkgconfig/cmake-config names with _64 for 64-bit
    # FIXME: investigate if this is actually ok? maybe not! maintaining old behavior for now
    (lib.cmakeBool "NO_SUFFIX64" true)
    (lib.cmakeBool "BUILD_STATIC_LIBS" enableStatic)
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER" "${stdenv.cc.targetPrefix}gfortran")
    # Disable the LAPACK test suite which is very slow and isn't part of the make test target
    # Somewhat confusingly this overall-sounding flag turns off only the LAPACK tests
    (lib.cmakeBool "BUILD_TESTING" false)
  ]
  ++ lib.optionals (config ? BINARY) [
    (lib.cmakeFeature "BINARY" (toString config.BINARY))
  ]
  ++ lib.optionals (config ? MACOSX_DEPLOYMENT_TARGET) [
    (lib.cmakeFeature "CMAKE_OSX_DEPLOYMENT_TARGET" config.MACOSX_DEPLOYMENT_TARGET)
  ]
  ++ lib.optionals (config ? NO_AVX512) [
    (lib.cmakeBool "NO_AVX512" config.NO_AVX512)
  ]
  ++ lib.optionals singleThreaded [
    # As described on https://github.com/OpenMathLib/OpenBLAS/wiki/Faq/4bded95e8dc8aadc70ce65267d1093ca7bdefc4c#multi-threaded
    (lib.cmakeBool "USE_THREAD" false)
    (lib.cmakeBool "USE_LOCKING" true) # available with openblas >= 0.3.7
    (lib.cmakeBool "USE_OPENMP" false) # openblas will refuse building with both USE_OPENMP=ON and USE_THREAD=OFF
  ];

  doCheck = true;

  postInstall = ''
        # Provide headers in /include directly for compat with some consumers like flint
        (cd $dev/include && ln -sf openblas/*.h .)

        # Write pkgconfig aliases. Upstream report:
        # https://github.com/OpenMathLib/OpenBLAS/issues/1740
        for alias in blas cblas lapack; do
          cat <<EOF > $out/lib/pkgconfig/$alias.pc
    Name: $alias
    Version: ${finalAttrs.version}
    Description: $alias provided by the OpenBLAS package.
    Cflags: -I$dev/include
    Libs: -L$out/lib -lopenblas
    EOF
        done

        # Setup symlinks for blas / lapack
  ''
  + lib.optionalString stdenv.hostPlatform.isMinGW ''
    ln -s $out/bin/*.dll $out/lib
  ''
  + lib.optionalString enableShared ''
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libblas${shlibExt}
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libcblas${shlibExt}
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapack${shlibExt}
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapacke${shlibExt}
  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux && enableShared) ''
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libblas${shlibExt}.3
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libcblas${shlibExt}.3
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapack${shlibExt}.3
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapacke${shlibExt}.3
  ''
  + lib.optionalString enableStatic ''
    ln -s $out/lib/libopenblas.a $out/lib/libblas.a
    ln -s $out/lib/libopenblas.a $out/lib/libcblas.a
    ln -s $out/lib/libopenblas.a $out/lib/liblapack.a
    ln -s $out/lib/libopenblas.a $out/lib/liblapacke.a
  '';

  passthru.tests = {
    inherit (python3.pkgs) numpy scipy scikit-learn;
    inherit
      ceres-solver
      flint
      giac
      octave
      opencv
      R
      ;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    cmake = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "OpenBLAS" ];
    };
  };

  meta = {
    description = "Basic Linear Algebra Subprograms";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/OpenMathLib/OpenBLAS";
    platforms = lib.attrNames configs;
    maintainers = with lib.maintainers; [ ttuegel ];
    pkgConfigModules = [
      "openblas"
      "blas"
      "cblas"
      "lapack"
    ];
  };
})
