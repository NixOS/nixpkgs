{stdenv, fetchurl, libgpgerror}:

stdenv.mkDerivation {
  name = "libgcrypt-1.2.4";
  src = fetchurl {
    url = ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.2.4.tar.gz;
    sha256 = "1v6rbx2jpwvh9jwf8n91da2p66v2gzmym6s3h1fidfdy7qqkyg6g";
  };

  buildInputs = [libgpgerror];
}
