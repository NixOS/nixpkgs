{ stdenv, fetchurl, icu, expat, zlib, bzip2, python, version }:

assert version == "1.38.0";

stdenv.mkDerivation {
  name = "boost-1.38.0";
  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";
  };
  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_38_0.tar.bz2";
    sha256 = "0rk044s4m7l4sma6anml34vxcd9w0fzcy1cy7csbzynjyida9qry";
  };
  buildInputs = [icu expat zlib bzip2 python];
  preConfigure =
    "sed -e 's@^BJAM_CONFIG=\"\"@BJAM_CONFIG=\"-sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=system variant=debug,release threading=single,multi link=shared,static\"@g' -i configure";
  configureFlags = "--with-icu=${icu} --with-python=${python}";
}
