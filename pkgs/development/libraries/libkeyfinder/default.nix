{ lib, stdenv, fetchFromGitHub, cmake, fftw, catch2 }:

stdenv.mkDerivation rec {
  pname = "libkeyfinder";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "libkeyfinder";
    rev = "v${version}";
    sha256 = "sha256-4jbnsKMGJKUIRfRPymGGgqPgwPyLInc6rLvCXnOcQ5g=";
  };

  # needed for finding libkeyfinder.so to link it into keyfinder-tests executable
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw ];

  checkInputs = [ catch2 ];

  doCheck = true;

  meta = with lib; {
    description = "Musical key detection for digital audio (C++ library)";
    homepage = "https://mixxxdj.github.io/libkeyfinder/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
