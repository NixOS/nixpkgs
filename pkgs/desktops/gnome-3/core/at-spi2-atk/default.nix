{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xlibs, libXi
, intltool, dbus_glib, at_spi2_core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.8";
  versionMinor = "0";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "085sqww174vl3i9ccb477v706rkjs2d107rl96ma1kbl2jyar226";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xlibs.libXtst libXi
                  intltool dbus_glib at_spi2_core libSM ];
}
