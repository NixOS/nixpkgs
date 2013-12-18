{ stdenv, fetchurl, pcre }:

let version = "1.0.10"; in

stdenv.mkDerivation {
  name = "classads-${version}";

  src = fetchurl {
    url = "ftp://ftp.cs.wisc.edu/condor/classad/c++/classads-${version}.tar.gz";
    sha256 = "1czgj53gnfkq3ncwlsrwnr4y91wgz35sbicgkp4npfrajqizxqnd";
  };

  buildInputs = [ pcre ];

  configureFlags = ''                                                  
    --enable-namespace --enable-flexible-member
  '';
  
  meta = {
    homepage = http://www.cs.wisc.edu/condor/classad/;
    description = "The Classified Advertisements library provides a generic means for matching resources";
    license = "Apache-2.0";
  };
}
