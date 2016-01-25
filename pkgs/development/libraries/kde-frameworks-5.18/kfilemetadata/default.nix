{ kdeFramework, lib, copyPathsToStore, extra-cmake-modules
, attr, ebook_tools, exiv2, ffmpeg, karchive, ki18n, poppler, qtbase, taglib
}:

kdeFramework {
  name = "kfilemetadata";
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ attr ebook_tools exiv2 ffmpeg karchive poppler taglib ];
  propagatedBuildInputs = [ qtbase ki18n ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
