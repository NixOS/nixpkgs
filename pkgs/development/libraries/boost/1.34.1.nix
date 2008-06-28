{stdenv, fetchurl, icu, zlib, bzip2, python, version}:

assert version == "1.34.1";

stdenv.mkDerivation {
  name = "boost-1.34.1";
  src = fetchurl {
    url = mirror://sourceforge/boost/boost_1_34_1.tar.bz2;
    sha256 = "0k7cjsgg3iqy49f9nnhyp945yry0bichd88p04sg3915n1snr1hg";
  };
  buildInputs = [icu zlib bzip2 python];
  preConfigure="
    sed -e 's@^BJAM_CONFIG=\"\"@BJAM_CONFIG=\"--layout=system release threading=multi link=shared\"@g' -i configure
  ";
  patches = [./gcc-4.2.patch];
  configureFlags="--with-icu=${icu}";
}
