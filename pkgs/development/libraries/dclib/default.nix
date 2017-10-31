{stdenv, fetchurl, libxml2, openssl, bzip2}:

stdenv.mkDerivation {
  name = "dclib-0.3.7";

  src = fetchurl {
    url = ftp://ftp.debian.nl/pub/freebsd/ports/distfiles/dclib-0.3.7.tar.bz2;
    sha256 = "02jdzm5hqzs1dv2rd596vgpcjaapm55pqqapz5m94l30v4q72rfc";
  };

  buildInputs = [libxml2 openssl bzip2];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
