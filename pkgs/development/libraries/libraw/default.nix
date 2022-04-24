{ lib, stdenv, fetchFromGitHub, autoreconfHook, lcms2, pkg-config }:

stdenv.mkDerivation {
  pname = "libraw";
  version = "unstable-2021-12-03";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = "52b2fc52e93a566e7e05eaa44cada58e3360b6ad";
    sha256 = "kW0R4iPuqnFuWYDrl46ok3kaPcGgY2MqZT7mqVX+BDQ=";
  };

  outputs = [ "out" "lib" "dev" "doc" ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}

