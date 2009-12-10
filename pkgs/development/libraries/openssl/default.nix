{stdenv, fetchurl, perl}:

stdenv.mkDerivation (rec {
  name = "openssl-0.9.8k";
  
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.8k.tar.gz;
    sha1 = "3ba079f91d3c1ec90a36dcd1d43857165035703f";
  };
  
  buildInputs = [perl];

  configureScript = "./config";
  
  configureFlags = "shared";

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
  };
} // (if stdenv.isDarwin then { patches = [ ./darwin-arch.patch ]; } else {}))
