{ kdeFramework, lib, copyPathsToStore, extra-cmake-modules
, attr, ebook_tools, exiv2, ffmpeg, karchive, ki18n, poppler, qtbase, taglib
}:

kdeFramework {
  name = "kfilemetadata";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ];
  propagatedBuildInputs = [
    attr ebook_tools exiv2 ffmpeg karchive ki18n poppler qtbase taglib
  ];
}
