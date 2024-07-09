{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gfortran
, blas
, lapack
}:

assert !blas.isILP64;
assert !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "harminv";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HV8xylK2IOvbONYGgyaqAabp6xA7/uvN4DU7upIlZh0=";
  };

  # File is missing in the git checkout but required by autotools
  postPatch = ''
    touch ChangeLog
  '';

  nativeBuildInputs = [ autoreconfHook gfortran ];

  buildInputs = [ blas lapack ];

  configureFlags = [
    "--enable-shared"
    "--enable-maintainer-mode"
  ];

  meta = with lib; {
    description = "Harmonic inversion algorithm of Mandelshtam: decompose signal into sum of decaying sinusoids";
    homepage = "https://github.com/NanoComp/harminv";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ sheepforce markuskowa ];
    platforms = platforms.linux;
  };
}
