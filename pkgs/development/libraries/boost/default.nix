{stdenv, fetchurl, icu, zlib, bzip2, python}:

stdenv.mkDerivation {
  name = "boost-1.34.0";
  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/boost/boost_1_34_0.tar.bz2;
    sha256 = "1lpganl8grvmy8rsbps5688yqiswvixjwz15d0kjfndp87xbhp25";
  };
  buildInputs = [icu zlib bzip2 python];
  preConfigure="
    sed -e 's@^BJAM_CONFIG=\"\"@BJAM_CONFIG=\"--layout=system release threading=multi link=shared\"@g' -i configure
  ";
  configureFlags="--with-icu=${icu}";
}
