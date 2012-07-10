{ stdenv, fetchurl, python, pkgconfig, popt, libX11, libICE, xlibs, libXi
, intltool, dbus_glib }:

stdenv.mkDerivation {
  name = "at-spi2-core-2.5.3";

  src = fetchurl {
    url = mirror://gnome/sources/at-spi2-core/2.5/at-spi2-core-2.5.3.tar.xz;
    sha256 = "0g1w8k13xjz6jcbkdy3h8w4x8g5g1f0nwykidairvfyi6yi9xdpm";
  };

  buildInputs = [ python pkgconfig popt libX11 libICE xlibs.libXtst libXi
                  intltool dbus_glib ];
}
