{ fetchurl, stdenv, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.26";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/libwacom/${name}.tar.bz2";
    sha256 = "0xpvkjvzaj9blcmw8ha46616bzfivj99kwzvr91clxd6iaf11r63";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = http://sourceforge.net/projects/linuxwacom/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
  };
}
