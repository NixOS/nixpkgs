{ fetchurl, stdenv, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.31";

  src = fetchurl {
    url = "https://github.com/linuxwacom/libwacom/releases/download/${name}/${name}.tar.bz2";
    sha256 = "00xzkxhm0s9bvhbf27hscjbh17wa8lcgvxjqbmzm527f9cjqrm8q";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://linuxwacom.github.io/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    license = licenses.mit;
  };
}
