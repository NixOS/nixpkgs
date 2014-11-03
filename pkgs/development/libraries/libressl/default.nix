{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.0.5";

  src = fetchurl {
    url    = "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${name}.tar.gz";
    sha256 = "16pwgmj90k10pf03il39lnck5kqw59hj0fp2qhmgsgmrvssn6m1z";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
