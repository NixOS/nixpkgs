{ kdeFramework, lib, copyPathsToStore, ecm
, attr, ebook_tools, exiv2, ffmpeg, karchive, ki18n, poppler, qtbase, taglib
}:

kdeFramework {
  name = "kfilemetadata";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    attr ebook_tools exiv2 ffmpeg karchive ki18n poppler qtbase taglib
  ];
}
