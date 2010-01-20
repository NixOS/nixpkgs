{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "openssl-0.9.8l";
  
  src = fetchurl {
    url = "http://www.openssl.org/source/${name}.tar.gz";
    sha1 = "d3fb6ec89532ab40646b65af179bb1770f7ca28f";
  };

  patches = [ ./darwin-arch.patch ];
  
  buildInputs = [ perl ];

  configureScript = "./config";
  
  configureFlags = "shared";

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
  };
}
