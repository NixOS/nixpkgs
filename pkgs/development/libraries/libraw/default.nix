{ lib, stdenv, fetchFromGitHub, autoreconfHook, lcms2, pkg-config }:

stdenv.mkDerivation {
  pname = "libraw";
  version = "0.20.2.p2";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = "fedad11e87daad7b7d389a3ef84ccf10b5e84710"; # current 0.20-stable branch
    sha256 = "1mklf8lzybzyg75ja34822xlv6h9nw93griyrjjna7darl1dyvja";
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

