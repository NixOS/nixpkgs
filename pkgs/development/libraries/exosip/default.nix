{stdenv, fetchurl, libosip, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "4.0.0";
  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/exosip/libeXosip2-${version}.tar.gz";
    sha256 = "1rdjr3x7s992w004cqf4xji1522an9rpzsr9wvyhp685khmahrsj";
  };
  name = "libexosip2-${version}";

  buildInputs = [ libosip openssl pkgconfig ];
      
  meta = {
    license = "GPLv2+";
    description = "Library that hides the complexity of using the SIP protocol";
  };
}
