{ mkDerivation
, lib
, extra-cmake-modules
, attr
, ebook_tools
, exiv2
, ffmpeg
, karchive
, kcoreaddons
, ki18n
, poppler
, qtbase
, qtmultimedia
, taglib
}:

mkDerivation {
  pname = "kfilemetadata";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attr
    ebook_tools
    exiv2
    ffmpeg
    karchive
    kcoreaddons
    ki18n
    poppler
    qtbase
    qtmultimedia
    taglib
  ];
  patches = [
    ./cmake-install-paths.patch
  ];
}
