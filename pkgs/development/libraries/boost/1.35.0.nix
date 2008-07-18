{ stdenv, fetchurl, icu, zlib, bzip2, python, version}:

assert version == "1.35.0";

stdenv.mkDerivation {
  name = "boost-1.35.0";
  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";
  };
  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_35_0.tar.bz2";
    sha256 = "f8bf7368a22ccf2e2cf77048ab2129744be4c03f8488c76ad31c0aa229b280da";
  };
  buildInputs = [icu zlib bzip2 python];
  preConfigure =
    "sed -e 's@^BJAM_CONFIG=\"\"@BJAM_CONFIG=\"--layout=system variant=debug,release threading=single,multi link=shared,static\"@g' -i configure";
  configureFlags = "--with-icu=${icu} --with-python=${python}";
}
