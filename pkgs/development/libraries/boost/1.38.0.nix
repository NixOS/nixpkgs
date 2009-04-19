{ stdenv, fetchurl, icu, expat, zlib, bzip2, python
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? true
, enableStatic ? false
}:

let

  variant = stdenv.lib.concatStringsSep ","
    (stdenv.lib.optional enableRelease "release" ++
     stdenv.lib.optional enableDebug "debug");

  threading = stdenv.lib.concatStringsSep ","
    (stdenv.lib.optional enableSingleThreaded "single" ++
     stdenv.lib.optional enableMultiThreaded "multi");

  link = stdenv.lib.concatStringsSep ","
    (stdenv.lib.optional enableShared "shared" ++
     stdenv.lib.optional enableStatic "static");

in

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

  patches = [ ./classr.patch ];
  
  buildInputs = [icu expat zlib bzip2 python];

  preBuild = ''
    makeFlagsArray=(BJAM_CONFIG="-sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=system variant=${variant} threading=${threading} link=${link}")
  '';
    
  configureFlags = "--with-icu=${icu} --with-python=${python}";
}
