{ stdenv, fetchurl }:

let version = "1.0.4"; in

stdenv.mkDerivation {
  name = "classads-${version}";

  src = fetchurl {
    url = "ftp://ftp.cs.wisc.edu/condor/classad/c++/classads-${version}.tar.gz";
    sha256 = "80b11c6d383891c90e04e403b2f282e91177940c3fe536082899fbfb9e854d24";
  };

  configureFlags = ''                                                  
    --enable-namespace --enable-flexible-member
  '';
  
  meta = {
    homepage = http://www.cs.wisc.edu/condor/classad/;
    description = "The Classified Advertisements library provides a generic means for matching resources.";
    license = "Apache-2.0";
  };
}
