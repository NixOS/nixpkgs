{ stdenv, fetchurl, python, pkgconfig, popt, libX11, xextproto, libSM, libICE, libXtst, libXi
, intltool, dbus_glib }:

stdenv.mkDerivation rec {

  versionMajor = "2.6";
  versionMinor = "3";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1snh2lmry33756gw5pfjxir3g4lrrx9bhadkaz8cyiz88sp8fi7w";
  };

  buildInputs = [ python pkgconfig popt libX11 xextproto libSM libICE libXtst libXi intltool dbus_glib ];
}
