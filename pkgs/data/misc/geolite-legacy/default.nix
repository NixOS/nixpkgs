{ stdenv, fetchurl }:

let
  fetchDB = src: name: sha256: fetchurl {
    inherit name sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };
in
stdenv.mkDerivation rec {
  name = "geolite-legacy-${version}";
  version = "2016-05-16";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "GeoIP.dat.gz"
    "1fcbbbdqbxgqmgk61awzbbnd7d9yr2hnfmbc5z5z5s77aw8i8nkj";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "GeoIPv6.dat.gz"
    "06cx1fza11g25ckjkih6p4awk2pg0jwr421fh8bijwx6i550paca";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "GeoIPCity.dat.xz"
    "1246328q4bhrri15pywkhbaz362ch1vnfw3h0qr8wn8f6ilix6nd";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "GeoIPCityv6.dat.gz"
    "1v8wdqh6yjicb7bdcxp7v5dimlrny1fiynf4wr6wh65vr738csy2";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "GeoIPASNum.dat.gz"
    "1nplklc88jn0iqla9ar5vgcq4wvkqkd5pbgvn89757466dl1igiw";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "GeoIPASNumv6.dat.gz"
    "06wmjr4frc83v68abpnad8z9xy4fsjsvwild6bw7816w9rdvdqzw";

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
