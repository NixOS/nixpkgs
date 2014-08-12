{stdenv, fetchurl, libxml2, openssl, bzip2}:

stdenv.mkDerivation {
  name = "dclib-0.3.7";

  src = fetchurl {
    url = ftp://ftp.debian.nl/pub/freebsd/ports/distfiles/dclib-0.3.7.tar.bz2;
    md5 = "d35833414534bcac8ce2c8a62ce903a4";
  };

  buildInputs = [libxml2 openssl bzip2];
}
