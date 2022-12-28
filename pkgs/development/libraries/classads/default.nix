{ lib, stdenv, fetchurl, pcre }:

stdenv.mkDerivation rec {
  pname = "classads";
  version = "1.0.10";

  src = fetchurl {
    url = "ftp://ftp.cs.wisc.edu/condor/classad/c++/classads-${version}.tar.gz";
    sha256 = "1czgj53gnfkq3ncwlsrwnr4y91wgz35sbicgkp4npfrajqizxqnd";
  };

  buildInputs = [ pcre ];

  configureFlags = [
    "--enable-namespace" "--enable-flexible-member"
  ];

  meta = {
    homepage = "http://www.cs.wisc.edu/condor/classad/";
    description = "The Classified Advertisements library provides a generic means for matching resources";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
