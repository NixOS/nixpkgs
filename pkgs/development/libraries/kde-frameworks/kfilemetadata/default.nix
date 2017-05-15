{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  attr, ebook_tools, exiv2, ffmpeg, karchive, ki18n, poppler, qtbase, taglib
}:

mkDerivation {
  name = "kfilemetadata";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    attr ebook_tools exiv2 ffmpeg karchive ki18n poppler qtbase taglib
  ];
}
