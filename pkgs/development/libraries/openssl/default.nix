{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "openssl-0.9.8g";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/openssl/openssl-0.9.8g.tar.gz;
    sha256 = "1w0wj3pgg9ga0hay3jdxs9sl17bfw307b6qvkxn735fy8ml8h9hf";
  };
  buildInputs = [perl];
}
