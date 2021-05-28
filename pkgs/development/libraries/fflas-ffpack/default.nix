{ stdenv, fetchFromGitHub, autoreconfHook, givaro, pkgconfig, blas, lapack
, gmpxx
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "fflas-ffpack";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = version;
    sha256 = "1ynbjd72qrwp0b4kpn0p5d7gddpvj8dlb5fwdxajr5pvkvi3if74";
  };

  checkInputs = [
    gmpxx
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ] ++ stdenv.lib.optionals doCheck checkInputs;

  buildInputs = [ givaro blas lapack ];

  configureFlags = [
    "--with-blas-libs=-lcblas"
    "--with-lapack-libs=-llapacke"
  ] ++ stdenv.lib.optionals stdenv.isx86_64 [
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

  meta = with stdenv.lib; {
    inherit version;
    description = ''Finite Field Linear Algebra Subroutines'';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = platforms.unix;
    homepage = "https://linbox-team.github.io/fflas-ffpack/";
  };
}
