{stdenv, fetchurl, libosip, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "3.5.0";
  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/exosip/libeXosip2-3.5.0.tar.gz;
    sha256 = "1z0s8qxxvyaksnnb9srfi3aipkkb7c1rsxdywl9xyxgnlri0w0a6";
  };
  name = "libexosip2-${version}";

  buildInputs = [ libosip openssl pkgconfig ];
      
  meta = {
    license = "GPLv2+";
    description = "Library that hides the complexity of using the SIP protocol";
  };
}
