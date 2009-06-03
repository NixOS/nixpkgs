{ stdenv, fetchurl, python, pkgconfig, popt, atk, gtk, libX11, libICE, libXtst, libXi
, intltool, libbonobo, ORBit2}:

stdenv.mkDerivation {
  name = "at-spi-1.26.0";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/at-spi-1.26.0.tar.bz2;
    sha256 = "0kb4n9xi66igg6fgs64q44cskx45v9mgn5psfbqpbykpl9rr935v";
  };
  buildInputs = [ python pkgconfig popt atk gtk libX11 libICE libXtst libXi
                  intltool libbonobo ORBit2 ];
}
