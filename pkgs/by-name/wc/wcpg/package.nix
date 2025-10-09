{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  blas,
  gmp,
  lapack,
  libf2c,
  mpfi,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "wcpg";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "fixif";
    repo = "wcpg";
    rev = version;
    sha256 = "sha256-uA/ENjf4urEO+lqebkp/k54199o2434FYgPSmYCG4UA=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    blas
    gmp
    lapack
    libf2c
    mpfi
    mpfr
  ];

  meta = with lib; {
    description = "Worst-Case Peak-Gain library";
    homepage = "https://github.com/fixif/WCPG";
    license = licenses.cecill-b;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wegank ];
  };
}
