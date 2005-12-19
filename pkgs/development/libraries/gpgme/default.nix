{stdenv, fetchurl, libgpgerror, gnupg}:

stdenv.mkDerivation {
  name = "gpgme-1.0.3";
  src = fetchurl {
    url = ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.0.3.tar.gz;
    md5 = "4d33cbdf844fcee1c724e4cf2a32dd11";
  };
  buildInputs = [libgpgerror gnupg];
}
