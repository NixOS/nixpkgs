{ stdenv
, fetchFromGitHub
, autoreconfHook
, givaro
, pkgconfig
, blas
, lapack
, fflas-ffpack
, gmpxx
, withSage ? false # sage support
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "linbox";
  version = "1.6.3";


  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = "v${version}";
    sha256 = "10j6dspbsq7d2l4q3y0c1l1xwmaqqba2fxg59q5bhgk9h5d7q571";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    givaro
    blas
    gmpxx
    fflas-ffpack
  ];

  configureFlags = [
    "--with-blas-libs=-lblas"
    "--disable-optimization"
  ] ++ stdenv.lib.optionals stdenv.isx86_64 [
    # disable SIMD instructions (which are enabled *when available* by default)
    "--${if stdenv.hostPlatform.sse3Support   then "enable" else "disable"}-sse3"
    "--${if stdenv.hostPlatform.ssse3Support  then "enable" else "disable"}-ssse3"
    "--${if stdenv.hostPlatform.sse4_1Support then "enable" else "disable"}-sse41"
    "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-sse42"
    "--${if stdenv.hostPlatform.avxSupport    then "enable" else "disable"}-avx"
    "--${if stdenv.hostPlatform.avx2Support   then "enable" else "disable"}-avx2"
    "--${if stdenv.hostPlatform.fmaSupport    then "enable" else "disable"}-fma"
    "--${if stdenv.hostPlatform.fma4Support   then "enable" else "disable"}-fma4"
  ] ++ stdenv.lib.optionals withSage [
    "--enable-sage"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    inherit version;
    description = "C++ library for exact, high-performance linear algebra";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.timokau];
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://linalg.org/";
  };
}
