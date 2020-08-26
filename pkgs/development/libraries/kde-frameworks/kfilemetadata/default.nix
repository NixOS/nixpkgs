{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  attr, ebook_tools, exiv2, ffmpeg_3, karchive, kcoreaddons, ki18n, poppler, qtbase, qtmultimedia, taglib
}:

mkDerivation {
  name = "kfilemetadata";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attr ebook_tools exiv2 ffmpeg_3 karchive kcoreaddons ki18n poppler qtbase qtmultimedia
    taglib
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
