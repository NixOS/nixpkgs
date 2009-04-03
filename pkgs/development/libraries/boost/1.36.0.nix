{stdenv, fetchurl, icu, expat, zlib, bzip2, python}:

stdenv.mkDerivation {
  name = "boost-1.36.0";
  
  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";
  };
  
  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_36_0.tar.bz2";
    sha256 = "1vydzfvzg0fkzixkr2jikvcc0zbh5qgw98hr6nhj0z12ppxhqjls";
  };
  
  buildInputs = [icu expat zlib bzip2 python];

  preBuild = ''
    makeFlagsArray=(BJAM_CONFIG="-sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=system variant=release threading=multi link=shared")
  '';
    
  configureFlags = "--with-icu=${icu} --with-python=${python}";
}
