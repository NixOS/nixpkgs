{ lib, stdenv, fetchFromGitHub, autoreconfHook, givaro, pkg-config, blas, lapack
, gmpxx
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "fflas-ffpack";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Eztc2jUyKRVUiZkYEh+IFHkDuPIy+Gx3ZW/MsuOVaMc=";
  };

  nativeCheckInputs = [
    gmpxx
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ] ++ lib.optionals doCheck nativeCheckInputs;

  buildInputs = [ givaro blas lapack ];

  configureFlags = [
    "--with-blas-libs=-lcblas"
    "--with-lapack-libs=-llapacke"
    "--without-archnative"
  ] ++ lib.optionals stdenv.isx86_64 [
    # disable SIMD instructions (which are enabled *when available* by default)
    # for now we need to be careful to disable *all* relevant versions of an instruction set explicitly (https://github.com/linbox-team/fflas-ffpack/issues/284)
    "--${if stdenv.hostPlatform.sse3Support   then "enable" else "disable"}-sse3"
    "--${if stdenv.hostPlatform.ssse3Support  then "enable" else "disable"}-ssse3"
    "--${if stdenv.hostPlatform.sse4_1Support then "enable" else "disable"}-sse41"
    "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-sse42"
    "--${if stdenv.hostPlatform.avxSupport    then "enable" else "disable"}-avx"
    "--${if stdenv.hostPlatform.avx2Support   then "enable" else "disable"}-avx2"
    "--${if stdenv.hostPlatform.avx512Support then "enable" else "disable"}-avx512f"
    "--${if stdenv.hostPlatform.avx512Support then "enable" else "disable"}-avx512dq"
    "--${if stdenv.hostPlatform.avx512Support then "enable" else "disable"}-avx512vl"
    "--${if stdenv.hostPlatform.fmaSupport    then "enable" else "disable"}-fma"
    "--${if stdenv.hostPlatform.fma4Support   then "enable" else "disable"}-fma4"
  ];
  doCheck = true;

  meta = with lib; {
    description = "Finite Field Linear Algebra Subroutines";
    mainProgram = "fflas-ffpack-config";
    license = licenses.lgpl21Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
    homepage = "https://linbox-team.github.io/fflas-ffpack/";
  };
}
