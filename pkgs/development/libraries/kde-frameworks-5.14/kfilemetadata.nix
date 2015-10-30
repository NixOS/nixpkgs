{ kdeFramework, lib
, extra-cmake-modules
, attr
, ebook_tools
, exiv2
, ffmpeg
, karchive
, ki18n
, popplerQt
, qtbase
, taglib
}:

kdeFramework {
  name = "kfilemetadata";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ attr ebook_tools exiv2 ffmpeg karchive ki18n popplerQt taglib ];
  propagatedBuildInputs = [ qtbase ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
