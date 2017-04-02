{ fetchurl, stdenv, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.22";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/libwacom/${name}.tar.bz2";
    sha256 = "1h10awwapj5v8nik220ga0raggv3lgaq0kzwlma2qjmzdhhrrhcp";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = http://sourceforge.net/projects/linuxwacom/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
  };
}
