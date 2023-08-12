{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, lcms2
, pkg-config

# for passthru.tests
, deepin
, freeimage
, hdrmerge
, imagemagick
, python3
}:

stdenv.mkDerivation rec {
  pname = "libraw";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = version;
    sha256 = "sha256-K9mULf6V/TCl5Vu4iuIdSGF9HzQlgNQLRFHIpNbmAlY";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-1729.patch";
      url = "https://github.com/LibRaw/LibRaw/commit/9ab70f6dca19229cb5caad7cc31af4e7501bac93.patch";
      hash = "sha256-OAyqphxvtSM15NI77HwtGTmTmP9YNu3xhZ6D1CceJ7I=";
    })
  ];

  outputs = [ "out" "lib" "dev" "doc" ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit imagemagick hdrmerge freeimage;
    inherit (deepin) deepin-image-viewer;
    inherit (python3.pkgs) rawkit;
  };

  meta = with lib; {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    license = with licenses; [ cddl lgpl2Plus ];
    platforms = platforms.unix;
  };
}

