{ lib, stdenv, fetchFromGitHub, autoreconfHook, lcms2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libraw";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = version;
    sha256 = "16nm4r2l5501c9zvz25pzajq5id592jhn068scjxhr8np2cblybc";
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

