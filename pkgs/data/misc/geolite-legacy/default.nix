{ stdenv, fetchurl }:

let
  fetchDB = src: name: sha256: fetchurl {
    inherit name sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2016-01-18";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "GeoIP.dat.gz"
    "07h1ha7z9i877ph41fw4blcfb11ynv8k9snrrsgsjrvv2yqvsc37";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "GeoIPv6.dat.gz"
    "14wsc0w8ir5q1lq6d9bpr03qvrbi2i0g04gkfcwbnh63yqxc31m9";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "GeoIPCity.dat.xz"
    "1nra64shc3bp1d6vk9rdv7wyd8jmkgsybqgr3imdg7fv837kwvnh";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "GeoIPCityv6.dat.gz"
    "1fksbnmda2a05cpax41h9r7jhi8102q41kl5nij4ai42d6yqy73x";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "GeoIPASNum.dat.gz"
    "00x6d11l8jxc1dj7p1kwmr3x1zwxwbv7xqbxj17j30s4qjmkb2i1";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "GeoIPASNumv6.dat.gz"
    "0r84ji86q4f6maw3scx9i054nzhjg4kb26r6fp1jdbiqjp8mhkyw";

  meta = with stdenv.lib; {
    inherit version;
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
