{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xorg, libXi
, intltool, dbus_glib, at_spi2_core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.22";
  versionMinor = "0";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "e8bdedbeb873eb229eb08c88e11d07713ec25ae175251648ad1a9da6c21113c1";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xorg.libXtst libXi
                  intltool dbus_glib at_spi2_core libSM ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
