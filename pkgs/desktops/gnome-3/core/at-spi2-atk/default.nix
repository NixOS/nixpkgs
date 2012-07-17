{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xlibs, libXi
, intltool, dbus_glib, gnome3, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.5";
  versionMinor = "4";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1bl5jl644slf5mmnr4z7xj433prvjjpgmv9rdmxdny23j08qa8vs";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xlibs.libXtst libXi
                  intltool dbus_glib gnome3.at_spi2_core libSM ];
}
