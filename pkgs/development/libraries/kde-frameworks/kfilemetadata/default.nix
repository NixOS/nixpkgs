{
  mkDerivation,
  extra-cmake-modules,
  attr, ebook_tools, exiv2, ffmpeg_3, karchive, kcoreaddons, ki18n, poppler, qtbase, qtmultimedia, taglib
}:

mkDerivation {
  name = "kfilemetadata";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attr ebook_tools exiv2 ffmpeg_3 karchive kcoreaddons ki18n poppler qtbase qtmultimedia
    taglib
  ];
  patches = [
    ./cmake-install-paths.patch
  ];
}
