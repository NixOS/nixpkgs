{ stdenv, fetchurl, cmake, rLang, zlib }:

stdenv.mkDerivation rec {
  name = "biolib";
  
  version = "0.0.1";
  
  src = fetchurl {
    url = "http://bio3.xparrot.eu/download/nix-biology/biolib-${version}.tar.gz";
    sha256 = "1la639rs0v4f3ayvarqv0yxwlnwn188bb1v71d2ybw1xr6gdy688";
  };

  buildInputs = [cmake rLang zlib];

  meta = {
    description = "BioLib";
    longDescription =
      ''
        BioLib brings together a set of opensource libraries written
        in C/C++ and makes them available for major Bio* languages:
        BioPerl, BioRuby, BioPython
      '';
    license = "GPL2";
    homepage = http://biolib.open-bio.org/; 
  };
}
