{ stdenv, fetchurl }:

let
  fetchDB = src: name: sha256: fetchurl {
    inherit name sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };
in
stdenv.mkDerivation rec {
  name = "geolite-legacy-${version}";
  version = "2016-05-02";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "GeoIP.dat.gz"
    "0g34nwilhim73f0qp0yq3lfx54c42wy70ra4dkmwlfddyq3ln0xd";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "GeoIPv6.dat.gz"
    "12k4nmfblm9c7kj4v7cyl6sgfgdfv2jdx4fl7nxfzpk1km7yc5na";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "GeoIPCity.dat.xz"
    "04bi7zmmm7v9gl9vhxh0fvqfhmg9ja1lan4ff0njx7qs7lz3ak88";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "GeoIPCityv6.dat.gz"
    "1sr2yapsfmdpl4zpf8i5rl3k65dgbq7bb1615g6wf60yw9ngh76x";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "GeoIPASNum.dat.gz"
    "04gyrb5qyy3i1p9lgnls90irq3s64y5qfcqj91nx4x68r7dixnai";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "GeoIPASNumv6.dat.gz"
    "1l9j97bk3mbv5b6lxva6ig590gl7097xr0vayz5mpsfx5d37r4zw";

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
