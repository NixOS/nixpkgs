{ stdenv, fetchurl
, pkgconfig, wxGTK
, ffmpeg, libexif
, cairo, pango }:

stdenv.mkDerivation rec {

  name = "wxSVG-${version}";
  srcName = "wxsvg-${version}";
  version = "1.5.11";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/${srcName}.tar.bz2";
    sha256 = "0m3ff8mjiq4hvy8rmxyc9fkpf24xwxhvr3a6jmvr2q5zc41xhz7x";
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
