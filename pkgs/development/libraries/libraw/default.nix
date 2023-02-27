{ lib, stdenv, fetchFromGitHub, autoreconfHook, lcms2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libraw";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = version;
    sha256 = "sha256-K9mULf6V/TCl5Vu4iuIdSGF9HzQlgNQLRFHIpNbmAlY";
  };

  outputs = [ "out" "lib" "dev" "doc" ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    license = with licenses; [ cddl lgpl2Plus ];
    platforms = platforms.unix;
  };
}

