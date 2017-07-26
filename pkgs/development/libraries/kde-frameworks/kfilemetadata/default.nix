{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  attr, ebook_tools, exiv2, ffmpeg, karchive, ki18n, poppler, qtbase, taglib
}:

mkDerivation {
  name = "kfilemetadata";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attr ebook_tools exiv2 ffmpeg karchive ki18n poppler taglib
  ];
  propagatedBuildInputs = [ qtbase ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
