{ stdenv, fetchurl, cmake, R, zlib }:

stdenv.mkDerivation rec {
  name = "biolib-${version}";

  version = "0.0.1";

  src = fetchurl {
    url = "http://bio3.xparrot.eu/download/nix-biology/biolib-${version}.tar.gz";
    sha256 = "1la639rs0v4f3ayvarqv0yxwlnwn188bb1v71d2ybw1xr6gdy688";
  };

  buildInputs = [cmake R zlib];

  meta = {
    homepage = "http://biolib.open-bio.org/";
    description = "BioLib";
    license = stdenv.lib.licenses.gpl2;
    longDescription = ''
      BioLib brings together a set of opensource libraries written
      in C/C++ and makes them available for major Bio* languages:
      BioPerl, BioRuby, BioPython
    '';
  };
}
