{ stdenv, fetchurl }:

let
  fetchDB = name: sha256: fetchurl {
    inherit sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${name}";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2015-04-21";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB "GeoLiteCountry/GeoIP.dat.gz"
    "15c7j6yyjl0k42ij7smdz2j451y3hhfbmxwkx8kp5ja0afrlw41k";
  srcGeoIPv6 = fetchDB "GeoIPv6.dat.gz"
    "0kz6yjprzqr2pi4rczbmw7489gdjzf957azahdqjai8fx0s5w93i";
  srcGeoLiteCity = fetchDB "GeoLiteCity.dat.xz"
    "1z40kfjwn90fln7nfnk5pwcn1wl9imw5jz6bcdy8yr552m2n31y7";
  srcGeoLiteCityv6 = fetchDB "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
    "1k8sig8w43cdm19rpwndr1akj1d3mxl5sch60qbinjrb05l6xbgv";
  srcGeoIPASNum = fetchDB "asnum/GeoIPASNum.dat.gz"
    "0r4v2zs4alxb46kz679hw4w34s7n9pxw32wcfs5x4nhnq051y6ms";
  srcGeoIPASNumv6 = fetchDB "asnum/GeoIPASNumv6.dat.gz"
    "04ciwh5gaxja4lzlsgbg1p7rkrhnn637m4nj9ld8sb36bl2ph6gc";

  meta = with stdenv.lib; {
    inherit version;
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = with licenses; cc-by-sa-30;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
