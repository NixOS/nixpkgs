{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.8d";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/openssl/openssl-0.9.8d.tar.gz;
    sha1 = "4136fba00303a3d319d2052bfa8e1f09a2e12fc2";
  };
  buildInputs = [perl];
}
