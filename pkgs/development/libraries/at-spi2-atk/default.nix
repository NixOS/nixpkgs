{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xorg, libXi
, intltool, dbus_glib, at_spi2_core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.20";
  versionMinor = "1";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "2358a794e918e8f47ce0c7370eee8fc8a6207ff1afe976ec9ff547a03277bf8e";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xorg.libXtst libXi
                  intltool dbus_glib at_spi2_core libSM ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
