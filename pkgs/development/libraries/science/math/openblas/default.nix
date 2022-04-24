{ lib, stdenv, fetchFromGitHub, perl, which
# Most packages depending on openblas expect integer width to match
# pointer width, but some expect to use 32-bit integers always
# (for compatibility with reference BLAS).
, blas64 ? null
# Multi-threaded applications must not call a threaded OpenBLAS
# (the only exception is when an application uses OpenMP as its
# *only* form of multi-threading). See
#     https://github.com/xianyi/OpenBLAS/wiki/Faq/4bded95e8dc8aadc70ce65267d1093ca7bdefc4c#multi-threaded
#     https://github.com/xianyi/OpenBLAS/issues/2543
# This flag builds a single-threaded OpenBLAS using the flags
# stated in thre.
, singleThreaded ? false
, buildPackages
# Select a specific optimization target (other than the default)
# See https://github.com/xianyi/OpenBLAS/blob/develop/TargetList.txt
, target ? null
# Select whether DYNAMIC_ARCH is enabled or not.
, dynamicArch ? null
# enable AVX512 optimized kernels.
# These kernels have been a source of trouble in the past.
# Use with caution.
, enableAVX512 ? false
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
}:

with lib;

let blas64_ = blas64; in

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
  };
in

let
  config =
    configs.${stdenv.hostPlatform.system}
    or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in

let
  blas64 =
    if blas64_ != null
      then blas64_
      else hasPrefix "x86_64" stdenv.hostPlatform.system;
  # Convert flag values to format OpenBLAS's build expects.
  # `toString` is almost what we need other than bools,
  # which we need to map {true -> 1, false -> 0}
  # (`toString` produces empty string `""` for false instead of `0`)
  mkMakeFlagValue = val:
    if !builtins.isBool val then toString val
    else if val then "1" else "0";
  mkMakeFlagsFromConfig = mapAttrsToList (var: val: "${var}=${mkMakeFlagValue val}");

  shlibExt = stdenv.hostPlatform.extensions.sharedLibrary;

in
stdenv.mkDerivation rec {
  pname = "openblas";
  version = "0.3.20";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "xianyi";
    repo = "OpenBLAS";
    rev = "v${version}";
    sha256 = "sha256-FLPVcepf7tv/es+4kur9Op7o3iVAAayuYN4hY/P4mmQ=";
  };

  inherit blas64;

  # Some hardening features are disabled due to sporadic failures in
  # OpenBLAS-based programs. The problem may not be with OpenBLAS itself, but
  # with how these flags interact with hardening measures used downstream.
  # In either case, OpenBLAS must only be used by trusted code--it is
  # inherently unsuitable for security-conscious applications--so there should
  # be no objection to disabling these hardening measures.
  hardeningDisable = [
    # don't modify or move the stack
    "stackprotector" "pic"
    # don't alter index arithmetic
    "strictoverflow"
    # don't interfere with dynamic target detection
    "relro" "bindnow"
  ];

  nativeBuildInputs = [
    perl
    which
  ];

  depsBuildBuild = [
    buildPackages.gfortran
    buildPackages.stdenv.cc
  ];

  makeFlags = mkMakeFlagsFromConfig (config // {
    FC = "${stdenv.cc.targetPrefix}gfortran";
    CC = "${stdenv.cc.targetPrefix}${if stdenv.cc.isClang then "clang" else "cc"}";
    PREFIX = placeholder "out";
    NUM_THREADS = 64;
    INTERFACE64 = blas64;
    NO_STATIC = !enableStatic;
    NO_SHARED = !enableShared;
    CROSS = stdenv.hostPlatform != stdenv.buildPlatform;
    HOSTCC = "cc";
    # Makefile.system only checks defined status
    # This seems to be a bug in the openblas Makefile:
    # on x86_64 it expects NO_BINARY_MODE=
    # but on aarch64 it expects NO_BINARY_MODE=0
    NO_BINARY_MODE = if stdenv.isx86_64
        then toString (stdenv.hostPlatform != stdenv.buildPlatform)
        else stdenv.hostPlatform != stdenv.buildPlatform;
  } // (lib.optionalAttrs singleThreaded {
    # As described on https://github.com/xianyi/OpenBLAS/wiki/Faq/4bded95e8dc8aadc70ce65267d1093ca7bdefc4c#multi-threaded
    USE_THREAD = false;
    USE_LOCKING = true; # available with openblas >= 0.3.7
    USE_OPENMP = false; # openblas will refuse building with both USE_OPENMP=1 and USE_THREAD=0
  }));

  doCheck = true;
  checkTarget = "tests";

  postInstall = ''
    # Write pkgconfig aliases. Upstream report:
    # https://github.com/xianyi/OpenBLAS/issues/1740
    for alias in blas cblas lapack; do
      cat <<EOF > $out/lib/pkgconfig/$alias.pc
Name: $alias
Version: ${version}
Description: $alias provided by the OpenBLAS package.
Cflags: -I$out/include
Libs: -L$out/lib -lopenblas
EOF
    done

    # Setup symlinks for blas / lapack
  '' + lib.optionalString enableShared ''
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libblas${shlibExt}
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libcblas${shlibExt}
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapack${shlibExt}
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapacke${shlibExt}
  '' + lib.optionalString (stdenv.hostPlatform.isLinux && enableShared) ''
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libblas${shlibExt}.3
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/libcblas${shlibExt}.3
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapack${shlibExt}.3
    ln -s $out/lib/libopenblas${shlibExt} $out/lib/liblapacke${shlibExt}.3
  '' + lib.optionalString enableStatic ''
    ln -s $out/lib/libopenblas.a $out/lib/libblas.a
    ln -s $out/lib/libopenblas.a $out/lib/libcblas.a
    ln -s $out/lib/libopenblas.a $out/lib/liblapack.a
    ln -s $out/lib/libopenblas.a $out/lib/liblapacke.a
  '';

  meta = with lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.bsd3;
    homepage = "https://github.com/xianyi/OpenBLAS";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel ];
  };
}
