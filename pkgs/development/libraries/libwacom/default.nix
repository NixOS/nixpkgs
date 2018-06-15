{ fetchurl, stdenv, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.29";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/libwacom/${name}.tar.bz2";
    sha256 = "1diklgcjhmvcxi9p1ifp6wcnyr6k7z9jhrlzfhzjqd6zipk01slw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://sourceforge.net/projects/linuxwacom/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
  };
}
