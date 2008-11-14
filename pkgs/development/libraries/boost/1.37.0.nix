{ stdenv, fetchurl, icu, expat, zlib, bzip2, python, version }:

assert version == "1.37.0";

stdenv.mkDerivation {
  name = "boost-1.37.0";
  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";
  };
  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_37_0.tar.bz2";
    sha256 = "0wjlmkp9klz6qfx02crw2w6py8k634m3l6hd9vfavfdif2gz8bnm";
  };
  buildInputs = [icu expat zlib bzip2 python];
  preConfigure =
    "sed -e 's@^BJAM_CONFIG=\"\"@BJAM_CONFIG=\"-sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=system variant=debug,release threading=single,multi link=shared,static\"@g' -i configure";
  configureFlags = "--with-icu=${icu} --with-python=${python}";
}
