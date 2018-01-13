{ stdenv, fetchurl, gfortran, perl, which, config, coreutils
# Most packages depending on openblas expect integer width to match
# pointer width, but some expect to use 32-bit integers always
# (for compatibility with reference BLAS).
, blas64 ? null
}:

with stdenv.lib;

let blas64_ = blas64; in

let
  # To add support for a new platform, add an element to this set.
  configs = {
    armv6l-linux = {
      BINARY = "32";
      TARGET = "ARMV6";
      DYNAMIC_ARCH = "0";
      CC = "gcc";
      USE_OPENMP = "1";
    };

    armv7l-linux = {
      BINARY = "32";
      TARGET = "ARMV7";
      DYNAMIC_ARCH = "0";
      CC = "gcc";
      USE_OPENMP = "1";
    };

    aarch64-linux = {
      BINARY = "64";
      TARGET = "ARMV8";
      DYNAMIC_ARCH = "1";
      CC = "gcc";
      USE_OPENMP = "1";
    };

    i686-linux = {
      BINARY = "32";
      TARGET = "P2";
      DYNAMIC_ARCH = "1";
      CC = "gcc";
      USE_OPENMP = "1";
    };

    x86_64-darwin = {
      BINARY = "64";
      TARGET = "ATHLON";
      DYNAMIC_ARCH = "1";
      # Note that clang is available through the stdenv on OSX and
      # thus is not an explicit dependency.
      CC = "clang";
      USE_OPENMP = "0";
      MACOSX_DEPLOYMENT_TARGET = "10.7";
    };

    x86_64-linux = {
      BINARY = "64";
      TARGET = "ATHLON";
      DYNAMIC_ARCH = "1";
      CC = "gcc";
      USE_OPENMP = "1";
    };
  };
in

let
  config =
    configs.${stdenv.system}
    or (throw "unsupported system: ${stdenv.system}");
in

let
  blas64 =
    if blas64_ != null
      then blas64_
      else hasPrefix "x86_64" stdenv.system;

  version = "0.2.20";
in
stdenv.mkDerivation {
  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/archive/v${version}.tar.gz";
    sha256 = "157kpkbpwlr57dkmqiwr3qp9fglfidagv7l6fibrhln6v4aqpwsy";
    name = "openblas-${version}.tar.gz";
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

  nativeBuildInputs =
    [gfortran perl which]
    ++ optionals stdenv.isDarwin [coreutils];

  makeFlags =
    [
      "FC=gfortran"
      ''PREFIX="''$(out)"''
      "NUM_THREADS=64"
      "INTERFACE64=${if blas64 then "1" else "0"}"
      "NO_STATIC=1"
    ] ++ stdenv.lib.optional (stdenv.hostPlatform.libc == "musl") "NO_AFFINITY=1"
    ++ mapAttrsToList (var: val: var + "=" + val) config;

  doCheck = true;
  checkTarget = "tests";

  meta = with stdenv.lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.bsd3;
    homepage = https://github.com/xianyi/OpenBLAS;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel ];
  };
}
