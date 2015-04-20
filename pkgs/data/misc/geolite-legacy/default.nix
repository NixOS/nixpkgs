{ stdenv, fetchurl }:

let
  fetchDB = name: sha256: fetchurl {
    inherit sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${name}.dat.gz";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2015-04-21";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB "GeoLiteCountry/GeoIP"
    "15c7j6yyjl0k42ij7smdz2j451y3hhfbmxwkx8kp5ja0afrlw41k";
  srcGeoIPv6 = fetchDB "GeoIPv6"
    "0kz6yjprzqr2pi4rczbmw7489gdjzf957azahdqjai8fx0s5w93i";
  srcGeoLiteCity = fetchDB "GeoLiteCity"
    "0lc696axcdgz7xrh9p6ac5aa7nlxfgngwyabjwqiwazz3wcmw05a";
  srcGeoLiteCityv6 = fetchDB "GeoLiteCityv6-beta/GeoLiteCityv6"
    "1k8sig8w43cdm19rpwndr1akj1d3mxl5sch60qbinjrb05l6xbgv";
  srcGeoIPASNum = fetchDB "asnum/GeoIPASNum"
    "0r4v2zs4alxb46kz679hw4w34s7n9pxw32wcfs5x4nhnq051y6ms";
  srcGeoIPASNumv6 = fetchDB "asnum/GeoIPASNumv6"
    "04ciwh5gaxja4lzlsgbg1p7rkrhnn637m4nj9ld8sb36bl2ph6gc";

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = with licenses; cc-by-sa-30;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
