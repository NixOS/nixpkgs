{ stdenv, fetchFromGitHub, fetchpatch, gfortran, perl, which, config, coreutils
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
      USE_OPENMP = if stdenv.hostPlatform.isMusl then "0" else "1";
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
in
stdenv.mkDerivation rec {
  name = "openblas-${version}";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "xianyi";
    repo = "OpenBLAS";
    rev = "v${version}";
    sha256 = "1dkwp4gz1hzpmhzks9y9ipb4c5h0r6c7yff62x3s8x9z6f8knaqc";
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

    patches = [
      # Backport of https://github.com/xianyi/OpenBLAS/pull/1667, which
      # is causing problems and was already accepted upstream.
      (fetchpatch {
        url = "https://github.com/xianyi/OpenBLAS/commit/5f2a3c05cd0e3872be3c5686b9da6b627658eeb7.patch";
        sha256 = "1qvxhk92likrshw6z6hjqxvkblwzgsbzis2b2f71bsvx9174qfk1";
      })
      # Double "MAX_ALLOCATING_THREADS", fix with Go and Octave
      # https://github.com/xianyi/OpenBLAS/pull/1663 (see also linked issue)
      (fetchpatch {
        url = "https://github.com/xianyi/OpenBLAS/commit/a49203b48c4a3d6f86413fc8c4b1fbfaa1946463.patch";
        sha256 = "0v6kjkbgbw7hli6xkism48wqpkypxmcqvxpx564snll049l2xzq2";
      })
    ];

  doCheck = true;
  checkTarget = "tests";

  meta = with stdenv.lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.bsd3;
    homepage = https://github.com/xianyi/OpenBLAS;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel ];
  };

  # We use linkName to pass a different name to --with-blas-libs for
  # fflas-ffpack and linbox, because we use blas on darwin but openblas
  # elsewhere.
  # See see https://github.com/NixOS/nixpkgs/pull/45013.
  passthru.linkName = "openblas";
}
