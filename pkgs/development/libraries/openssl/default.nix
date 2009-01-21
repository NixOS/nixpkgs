{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "openssl-0.9.8j";
  
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.8j.tar.gz;
    sha1 = "f70f7127a26e951e8a0d854c0c9e6b4c24df78e4";
  };
  
  buildInputs = [perl];

  configureScript = "./config";
  
  configureFlags = "shared";

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
  };
}
