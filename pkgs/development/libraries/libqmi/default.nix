{ stdenv, fetchurl, pkgconfig, glib, python, libgudev, libmbim }:

stdenv.mkDerivation rec {
  name = "libqmi-1.18.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${name}.tar.xz";
    sha256 = "1v4cz3nsmh7nn3smhlhwzrb7yh6l1f270bwf40qacxayjdajr950";
  };

  outputs = [ "out" "dev" "devdoc" ];

  preBuild = ''
    patchShebangs .
  '';

  buildInputs = [ pkgconfig glib python libgudev libmbim ];

  configureFlags = ["--enable-mbim-qmux" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/libqmi/;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ wkennington ];
  };
}
