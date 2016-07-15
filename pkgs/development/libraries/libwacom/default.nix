{ fetchurl, stdenv, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.19";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/libwacom/${name}.tar.bz2";
    sha256 = "1zsmp2l53fbfy6jykh4c0i127baf503lq2fvd5y1066ihp6qh3b2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = http://sourceforge.net/projects/linuxwacom/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
  };
}
