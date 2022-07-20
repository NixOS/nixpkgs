{ lib, stdenv, fetchFromGitHub, cmake, fftw, catch2 }:

stdenv.mkDerivation rec {
  pname = "libkeyfinder";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "libkeyfinder";
    rev = "v${version}";
    sha256 = "sha256-7w/Wc9ncLinbnM2q3yv5DBtFoJFAM2e9xAUTsqvE9mg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw ];

  checkInputs = [ catch2 ];

  doCheck = true;

  meta = with lib; {
    description = "Musical key detection for digital audio (C++ library)";
    homepage = "https://mixxxdj.github.io/libkeyfinder/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
