{ stdenv, fetchurl
, pkgconfig, wxGTK
, ffmpeg, libexif
, cairo, pango }:

stdenv.mkDerivation rec {

  pname = "wxSVG";
  srcName = "wxsvg-${version}";
  version = "1.5.22";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/${srcName}.tar.bz2";
    sha256 = "0agmmwg0zlsw1idygvqjpj1nk41akzlbdha0hsdk1k8ckz6niq8d";
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
