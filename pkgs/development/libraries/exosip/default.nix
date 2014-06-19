{stdenv, fetchurl, libosip, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "4.0.0";
  src = fetchurl {
    url = "mirror://savannah/exosip/libeXosip2-${version}.tar.gz";
    sha256 = "1rdjr3x7s992w004cqf4xji1522an9rpzsr9wvyhp685khmahrsj";
  };
  name = "libexosip2-${version}";

  buildInputs = [ libosip openssl pkgconfig ];
      
  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Library that hides the complexity of using the SIP protocol";
  };
}
