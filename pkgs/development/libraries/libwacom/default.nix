{ fetchurl, stdenv, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.28";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/libwacom/${name}.tar.bz2";
    sha256 = "1vv768870597rvwxdb59v6pjn1pxaxg4r6znbb5j3cl828q35mp7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://sourceforge.net/projects/linuxwacom/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
  };
}
