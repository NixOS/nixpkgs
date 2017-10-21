# in geoipDatabase, you can insert a package defining ${geoipDatabase}/share/GeoIP
# e.g. geolite-legacy
{ stdenv, fetchurl, pkgs, drvName ? "geoip", geoipDatabase ? "/var/lib/geoip-databases" }:

let version = "1.6.2";
    dataDir = if (stdenv.lib.isDerivation geoipDatabase) then "${toString geoipDatabase}/share/GeoIP" else geoipDatabase;
in stdenv.mkDerivation {
  name = "${drvName}-${version}";

  src = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-${version}.tar.gz";
    sha256 = "0dd6si4cvip73kxdn43apg6yygvaf7dnk5awqfg9w2fd2ll0qnh7";
  };

  postPatch = ''
    find . -name Makefile.in -exec sed -i -r 's#^pkgdatadir\s*=.+$#pkgdatadir = ${dataDir}#' {} \;
  '';

  meta = {
    description = "Geolocation API";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    homepage = http://geolite.maxmind.com/;
    downloadPage = "http://geolite.maxmind.com/download/";
  };
}
