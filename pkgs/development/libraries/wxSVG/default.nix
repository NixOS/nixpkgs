{ stdenv, fetchurl
, pkgconfig, wxGTK
, ffmpeg, libexif
, cairo, pango }:

stdenv.mkDerivation rec {

  name = "wxSVG-${version}";
  srcName = "wxsvg-${version}";
  version = "1.5.18";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/${srcName}.tar.bz2";
    sha256 = "0rzjrjx3vaz2z89zw5yv8qxclfpz7hpb17rgkib0a2r3kax2jz2h";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ wxGTK ffmpeg libexif ];

  buildInputs = [ cairo pango ];

  meta = with stdenv.lib; {
    description = "A SVG manipulation library built with wxWidgets";
    longDescription = ''
    wxSVG is C++ library to create, manipulate and render
    Scalable Vector Graphics (SVG) files with the wxWidgets toolkit.
    '';
    homepage = http://wxsvg.sourceforge.net/;
    license = with licenses; gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
