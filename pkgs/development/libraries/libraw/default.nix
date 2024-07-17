{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  lcms2,
  pkg-config,

  # for passthru.tests
  deepin,
  freeimage,
  hdrmerge,
  imagemagick,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libraw";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = version;
    hash = "sha256-p9CmOCulvV7+KKn1lXwpcysOo0+mD5UgPqy2ki0cIFE=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
  ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit imagemagick hdrmerge freeimage;
    inherit (deepin) deepin-image-viewer;
    inherit (python3.pkgs) rawkit;
  };

  meta = with lib; {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    license = with licenses; [
      cddl
      lgpl2Plus
    ];
    platforms = platforms.unix;
  };
}
