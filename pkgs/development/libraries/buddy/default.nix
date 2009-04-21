{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "buddy-2.4";
  
  meta = {
    homepage = "http://sourceforge.net/projects/buddy/";
    description = "binary decision diagram package";
    license = "as-is";
  };
  
  src = fetchurl {
    url = "mirror://sourceforge/buddy/${name}.tar.gz";
    sha256 = "0dl86l9xkl33wnkz684xa9axhcxx2zzi4q5lii0axnb9lsk81pyk";
  };
  
  configureFlags = "CFLAGS=-O3 CXXFLAGS=-O3";
  
  doCheck = true;
}
