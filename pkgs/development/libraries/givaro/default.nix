{ lib, stdenv, fetchFromGitHub, automake, autoconf, libtool, autoreconfHook, gmpxx }:
stdenv.mkDerivation rec {
  pname = "givaro";
  version = "4.1.1";
  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = "v${version}";
    sha256 = "11wz57q6ijsvfs5r82masxgr319as92syi78lnl9lgdblpc6xigk";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [autoconf automake libtool];
  propagatedBuildInputs = [ gmpxx ];

  configureFlags = [
    "--disable-optimization"
  ] ++ lib.optionals stdenv.isx86_64 [
    # disable SIMD instructions (which are enabled *when available* by default)
    "--${if stdenv.hostPlatform.sse3Support   then "enable" else "disable"}-sse3"
    "--${if stdenv.hostPlatform.ssse3Support  then "enable" else "disable"}-ssse3"
    "--${if stdenv.hostPlatform.sse4_1Support then "enable" else "disable"}-sse41"
    "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-sse42"
    "--${if stdenv.hostPlatform.avxSupport    then "enable" else "disable"}-avx"
    "--${if stdenv.hostPlatform.avx2Support   then "enable" else "disable"}-avx2"
    "--${if stdenv.hostPlatform.fmaSupport    then "enable" else "disable"}-fma"
    "--${if stdenv.hostPlatform.fma4Support   then "enable" else "disable"}-fma4"
  ];

  # On darwin, tests are linked to dylib in the nix store, so we need to make
  # sure tests run after installPhase.
  doInstallCheck = true;
  installCheckTarget = "check";
  doCheck = false;

  meta = {
    description = "A C++ library for arithmetic and algebraic computations";
    license = lib.licenses.cecill-b;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
