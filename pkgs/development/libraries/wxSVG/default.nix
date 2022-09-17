{ lib
, stdenv
, fetchurl
, cairo
, ffmpeg
, libexif
, pango
, pkg-config
, wxGTK
# darwin deps
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "wxSVG";
  version = "1.5.23";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/wxsvg-${version}.tar.bz2";
    hash = "sha256-Pwc2H6zH0YzBmpQN1zx4FC7V7sOMFNmTqFvwwGHcq7k=";
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
  ] ++ lib.optional stdenv.isDarwin Cocoa;

  meta = with lib; {
    homepage = "http://wxsvg.sourceforge.net/";
    description = "A SVG manipulation library built with wxWidgets";
    longDescription = ''
      wxSVG is C++ library to create, manipulate and render Scalable Vector
      Graphics (SVG) files with the wxWidgets toolkit.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    inherit (wxGTK.meta) platforms;
  };
}
