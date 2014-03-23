{ stdenv, fetchurl }:

let version = "1.6.0"; in

stdenv.mkDerivation {
  name = "geoip-${version}";

  src = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-${version}.tar.gz";
    sha256 = "0dd6si4cvip73kxdn43apg6yygvaf7dnk5awqfg9w2fd2ll0qnh7";
  };

  meta = {
    description = "Geolocation API";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}
