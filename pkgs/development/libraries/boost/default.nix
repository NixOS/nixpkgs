{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boost-1.34.0";
  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/boost/boost_1_34_0.tar.bz2;
    sha256 = "1lpganl8grvmy8rsbps5688yqiswvixjwz15d0kjfndp87xbhp25";
  };
}
