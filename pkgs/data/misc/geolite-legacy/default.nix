{ stdenv, fetchurl }:

let
  fetchDB = src: name: sha256: fetchurl {
    inherit name sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };
in
stdenv.mkDerivation rec {
  name = "geolite-legacy-${version}";
  version = "2016-02-29";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "GeoIP.dat.gz"
    "00y8j0jxk60wscm6wiz3mmmj5xfvwqnmxjm2ar8ngkl8mxzl12gm";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "GeoIPv6.dat.gz"
    "0l6wv246kzm63qqmqr9lzpbvbanfwfkvn9bj34jn2djp4rfrkjrf";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "GeoIPCity.dat.xz"
    "1095jar3vyax0gmj7wc0w28rpjmq2j1b6wk5yfaghyl87mad5q0f";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "GeoIPCityv6.dat.gz"
    "0fnlznn04lpkkd7sy9r9kdl3fcp8ix7msdrncwgz26dh537ml32z";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "GeoIPASNum.dat.gz"
    "10i4c8irvh9shbl3y0s0ffkm71vf3r290fvxjx20snqa558hkvib";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "GeoIPASNumv6.dat.gz"
    "1rvbjrj98pqj9w5ql5j49b3h40496g6aralpnz1gj21v6dfrd55n";

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
