{ lib
, stdenv
, fetchurl
, cairo
, ffmpeg
, libexif
, pango
, pkg-config
, wxGTK
}:

stdenv.mkDerivation rec {
  pname = "wxSVG";
  version = "1.5.22";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/wxsvg-${version}.tar.bz2";
    hash = "sha256-DeFozZ8MzTCbhkDBtuifKpBpg7wS7+dbDFzTDx6v9Sk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    cairo
    ffmpeg
    libexif
    pango
    wxGTK
  ];

  meta = with lib; {
    homepage = "http://wxsvg.sourceforge.net/";
    description = "A SVG manipulation library built with wxWidgets";
    longDescription = ''
      wxSVG is C++ library to create, manipulate and render Scalable Vector
      Graphics (SVG) files with the wxWidgets toolkit.
    '';
    license = with licenses; gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = wxGTK.meta.platforms;
  };
}
