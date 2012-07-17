{ stdenv, fetchurl, python, pkgconfig, popt, libX11, xextproto, libSM, libICE, libXtst, libXi
, intltool, dbus_glib }:

stdenv.mkDerivation rec {

  versionMajor = "2.5";
  versionMinor = "4";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "167zm1a36rd09wg161fsq8swnzdk3wv23kq49nd0l7gr89flf9ig";
  };

  buildInputs = [ python pkgconfig popt libX11 xextproto libSM libICE libXtst libXi intltool dbus_glib ];
}
