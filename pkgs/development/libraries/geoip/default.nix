# in geoipDatabase, you can insert a package defining ${geoipDatabase}/share/GeoIP
# e.g. geolite-legacy
{ stdenv, fetchurl, pkgs, drvName ? "geoip", geoipDatabase ? null }:

let version = "1.6.2"; in

stdenv.mkDerivation {
  name = "${drvName}-${version}";

  src = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-${version}.tar.gz";
    sha256 = "0dd6si4cvip73kxdn43apg6yygvaf7dnk5awqfg9w2fd2ll0qnh7";
  };

  postInstall = ''
    DB=${toString geoipDatabase}
    if [ -n "$DB" ]; then
      ln -s $DB/share/GeoIP $out/share/GeoIP
    fi
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
