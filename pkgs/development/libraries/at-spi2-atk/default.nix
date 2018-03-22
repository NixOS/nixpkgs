{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xorg, libXi
, intltool, dbus-glib, at-spi2-core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.26";
  versionMinor = "1";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "0x9vc99ni46fg5dzlx67vbw0zqffr24gz8jvbdxbmzyvc5xw5w5l";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ python popt atk libX11 libICE xorg.libXtst libXi
                  dbus-glib at-spi2-core libSM ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
