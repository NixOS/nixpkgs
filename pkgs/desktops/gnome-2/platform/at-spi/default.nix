{ stdenv, fetchurl, python, pkgconfig, popt, atk, gtk, libX11, libICE, libXtst, libXi
, intltool, libbonobo, ORBit2, GConf, dbus_glib }:

stdenv.mkDerivation {
  name = "at-spi-1.32.0";

  src = fetchurl {
    url = mirror://gnome/sources/at-spi/1.32/at-spi-1.32.0.tar.bz2;
    sha256 = "0fbh0afzw1gm4r2w68b8l0vhnia1qyzdl407vyxfw4v4fkm1v16c";
  };

  buildInputs = [ python pkgconfig popt atk gtk libX11 libICE libXtst libXi
                  intltool libbonobo ORBit2 GConf dbus_glib ];
}
