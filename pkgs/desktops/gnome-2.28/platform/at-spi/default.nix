{ stdenv, fetchurl, python, pkgconfig, popt, atk, gtk, libX11, libICE, libXtst, libXi
, intltool, libbonobo, ORBit2}:

stdenv.mkDerivation {
  name = "at-spi-1.28.0";
  src = fetchurl {
    url = nirror://gnome/sources/at-spi/1.28/at-spi-1.28.0.tar.bz2;
    sha256 = "0rv616drqpk58vybi3kalzyx06dxg26iwkbcrzk5563avhhj5qpb";
  };
  buildInputs = [ python pkgconfig popt atk gtk libX11 libICE libXtst libXi
                  intltool libbonobo ORBit2 ];
}
