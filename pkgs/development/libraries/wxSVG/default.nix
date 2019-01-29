{ stdenv, fetchurl
, pkgconfig, wxGTK
, ffmpeg, libexif
, cairo, pango }:

stdenv.mkDerivation rec {

  name = "wxSVG-${version}";
  srcName = "wxsvg-${version}";
  version = "1.5.15";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/${srcName}.tar.bz2";
    sha256 = "1f6fhkdmcfs8w7x08vhiqygss4qzcsimhd91h0j58zw25ky6rzqn";
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
