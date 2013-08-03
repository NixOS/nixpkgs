{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xlibs, libXi
, intltool, dbus_glib, at_spi2_core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.8";
  versionMinor = "1";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "01pxfnksixrjj27ivllpla54r6nkwsjj34acb0phmp76zna9nrgb";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xlibs.libXtst libXi
                  intltool dbus_glib at_spi2_core libSM ];
}
