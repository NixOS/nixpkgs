{ stdenv, fetchurl }:

let
  fetchDB = src: name: sha256: fetchurl {
    inherit name sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2015-11-23";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "GeoIP.dat.gz"
    "18nwbxy6l153zhd7fi4zdyibnmpcb197p3jlb9cjci852asd465l";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "GeoIPv6.dat.gz"
    "0dm8qvsx8vpwdv9y4z70jiws9bwmw10vdn5sc8jdms53p4rgr4n4";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "GeoIPCity.dat.xz"
    "1bq9kg6fsdsjssd3i6phq26n1px9jmljnq60gfsh8yb9s18hymfq";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "GeoIPCityv6.dat.gz"
    "0anx3kppql6wzkpmkf7k1322g4ragb5hh96apl71n2lmwb33i148";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "GeoIPASNum.dat.gz"
    "0zlc5gb0qy9am2xzpfv41i9wdydasrscmjwy1drccfsspqwrjvs7";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "GeoIPASNumv6.dat.gz"
    "0p9lwngvrk88an3kqx3v2b3kcs0l51mbrr7lwxg3ckkjyl9si1k3";

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
