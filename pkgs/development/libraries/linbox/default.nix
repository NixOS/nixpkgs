{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, givaro
, pkg-config
, blas
, lapack
, fflas-ffpack
, gmpxx
, withSage ? false # sage support
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "linbox";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mW84a98KPLqcHMjX3LIYTmVe0ngUdz6RJLpoDaAqKU8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/linbox-team/linbox/commit/4be26e9ef0eaf36a9909e5008940e8bf7dc625b6.patch";
      sha256 = "PX0Tik7blXOV2vHUq92xMxaADkNoNGiax4qrjQyGK6U=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    givaro
    blas
    gmpxx
    fflas-ffpack
  ];

  configureFlags = [
    "--with-blas-libs=-lblas"
    "--without-archnative"
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
  ] ++ lib.optionals withSage [
    "--enable-sage"
  ];

  # https://github.com/linbox-team/linbox/issues/304
  hardeningDisable = [ "fortify3" ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "C++ library for exact, high-performance linear algebra";
    mainProgram = "linbox-config";
    license = licenses.lgpl21Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
    homepage = "https://linalg.org/";
  };
}
