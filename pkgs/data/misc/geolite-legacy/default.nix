{ stdenv, fetchurl }:

let
  fetchDB = src: sha256: fetchurl {
    inherit sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };
in
stdenv.mkDerivation rec {
  name = "geolite-legacy-${version}";
  version = "2017-09-17";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz"
    "1xqxlnxxk8grqr0nr9vaf5r6z5bcdbadh83qhzr6jvhs20s37lsl";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz"
    "0g3am25jmhm3r51hvz9lknkrnzj98hxdxav2cvrhz6b7wndgyspk";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.gz"
    "1syw19gx2mpqz9ypkaq2gh712bv60a7rf56afzd3qzkmgf6rw1qr";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
    "0ihbqm1f5b9qb68i73ghmk30b6i2n53fmmhv2wadja5zcdpkhdvk";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz"
    "0adddsk0g9a3xaa0f8qx12s07n31wvirymjzrhnsg66i2qlm0h34";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz"
    "1qar0vdlpk3razq83l5fzb54zihs2sma8xgngpql8njfgby0w825";

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx fpletz ];
  };

  builder = ./builder.sh;
}
