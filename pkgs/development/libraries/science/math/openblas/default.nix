{ stdenv, fetchFromGitHub, fetchpatch, gfortran, perl, which, config, coreutils
# Most packages depending on openblas expect integer width to match
# pointer width, but some expect to use 32-bit integers always
# (for compatibility with reference BLAS).
, blas64 ? null
, buildPackages
}:

with stdenv.lib;

let blas64_ = blas64; in

let
  # To add support for a new platform, add an element to this set.
  configs = {
    armv6l-linux = {
      BINARY = 32;
      TARGET = "ARMV6";
      DYNAMIC_ARCH = false;
      USE_OPENMP = true;
    };

    armv7l-linux = {
      BINARY = 32;
      TARGET = "ARMV7";
      DYNAMIC_ARCH = false;
      USE_OPENMP = true;
    };

    aarch64-linux = {
      BINARY = 64;
      TARGET = "ARMV8";
      DYNAMIC_ARCH = true;
      USE_OPENMP = true;
    };

    i686-linux = {
      BINARY = 32;
      TARGET = "P2";
      DYNAMIC_ARCH = true;
      USE_OPENMP = true;
    };

    x86_64-darwin = {
      BINARY = 64;
      TARGET = "ATHLON";
      DYNAMIC_ARCH = true;
      USE_OPENMP = false;
      MACOSX_DEPLOYMENT_TARGET = "10.7";
    };

    x86_64-linux = {
      BINARY = 64;
      TARGET = "ATHLON";
      DYNAMIC_ARCH = true;
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
in
stdenv.mkDerivation rec {
  name = "openblas-${version}";
  version = "0.3.5";
  src = fetchFromGitHub {
    owner = "xianyi";
    repo = "OpenBLAS";
    rev = "v${version}";
    sha256 = "0hwfplr6ciqjvfqkya5vz92z2rx8bhdg5mkh923z246ylhs6d94k";
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
    buildPackages.gfortran
    buildPackages.stdenv.cc
  ] ++ optionals stdenv.isDarwin [
    coreutils
  ];

  makeFlags = mapAttrsToList (var: val: "${var}=${toString val}") (config // {
    FC = "${stdenv.cc.targetPrefix}gfortran";
    CC = "${stdenv.cc.targetPrefix}cc";
    PREFIX = placeholder "out";
    NUM_THREADS = 64;
    INTERFACE64 = blas64;
    NO_STATIC = true;
    CROSS = stdenv.hostPlatform != stdenv.buildPlatform;
    HOSTCC = "${buildPackages.stdenv.cc.targetPrefix}cc";
    NO_BINARY_MODE = stdenv.hostPlatform != stdenv.buildPlatform;
  });

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
  '';

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
