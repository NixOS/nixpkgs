{ stdenv, fetchurl, pkgconfig, glib, python }:

stdenv.mkDerivation rec {
  name = "libqmi-1.16.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${name}.tar.xz";
    sha256 = "0amshs06qc8zy8jz3r2yksqhhbamll7f893ll4zlvgr3zm3vpdks";
  };

  outputs = [ "out" "dev" "devdoc" ];

  preBuild = ''
    patchShebangs .
  '';

  buildInputs = [ pkgconfig glib python ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/libqmi/;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ wkennington ];
  };
}
