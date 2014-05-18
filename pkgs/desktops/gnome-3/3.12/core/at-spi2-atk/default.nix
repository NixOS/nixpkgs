{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xlibs, libXi
, intltool, dbus_glib, at_spi2_core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.12";
  versionMinor = "1";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "5fa9c527bdec028e06797563cd52d49bcf06f638549df983424d88db89bb1336";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xlibs.libXtst libXi
                  intltool dbus_glib at_spi2_core libSM ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
