{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "openssl-0.9.8i";
  
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.8i.tar.gz;
    sha1 = "b2e029cfb68bf32eae997d60317a40945db5a65f";
  };
  
  buildInputs = [perl];

  configureScript = "./config";
  
  configureFlags = "shared";

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
  };
}
