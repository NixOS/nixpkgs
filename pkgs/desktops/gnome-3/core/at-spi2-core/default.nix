{ stdenv, fetchurl, python, pkgconfig, popt, intltool, dbus_glib
, libX11, xextproto, libSM, libICE, libXtst, libXi }:

stdenv.mkDerivation rec {
  versionMajor = "2.10";
  versionMinor = "0";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1ns44yibdgcwzwri7sr075hfs5rh5lgxkh71247a0822az3mahcn";
  };

  buildInputs = [
    python pkgconfig popt  intltool dbus_glib
    libX11 xextproto libSM libICE libXtst libXi
  ];

  # ToDo: on non-NixOS we create a symlink from there?
  configureFlags = "--with-dbus-daemondir=/run/current-system/sw/bin/";
}
