{ fetchurl, stdenv, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-0.15";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/libwacom/${name}.tar.bz2";
    sha256 = "04vppdj99cc0ya44n8p7zjk9yyw03v6fksw0a9n1gpnnsn4wardb";
  };

  buildInputs = [ glib pkgconfig udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = http://sourceforge.net/projects/linuxwacom/;
    description = "libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
  };

}
