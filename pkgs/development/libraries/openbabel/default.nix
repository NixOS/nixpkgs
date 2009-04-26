{stdenv, fetchurl, zlib, libxml2}:

stdenv.mkDerivation {
  name = "openbabel-2.2.1";
  
  src = fetchurl { 
    url = mirror://sf/openbabel/openbabel-2.2.1.tar.gz;
    sha256 = "822345d70778de1d2d9afe65a659f1719b8ca300066fb1fa2f473bc97c457e80";
  };
  
  # TODO : perl & python bindings;
  # TODO : wxGTK: I have no time to compile
  # TODO : separate lib and apps
  buildInputs = [ zlib libxml2 ];
}
