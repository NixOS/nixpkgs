{ stdenv, fetchurl }:

let
  fetchDB = src: product: name: sha256: fetchurl {
    inherit name sha256;
    urls = [
      "https://headcounter.org/hydra/build/${version}/download/${product}"
      "https://geolite.maxmind.com/download/geoip/database/${src}"
    ];
  };

  # Annoyingly, these files are updated without a change in URL. In order to
  # cope with this, I (aszlig) have set up a mirror on my Hydra at:
  #
  # https://headcounter.org/hydra/jobset/aszlig/geoip-legacy-database-mirror
  #
  # Please make sure that whenever you update this to do the hash checks on the
  # upstream URL instead of blindly trusting my Hydra.
  #
  # The version here is the build ID of the "mirror" jobset and the right
  # one corresponding to the current date can be found here:
  #
  # https://headcounter.org/hydra/job/aszlig/geoip-legacy-database-mirror/mirror
  version = "810270";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "1" "GeoIP.dat.gz"
    "18nwbxy6l153zhd7fi4zdyibnmpcb197p3jlb9cjci852asd465l";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "4" "GeoIPv6.dat.gz"
    "0dm8qvsx8vpwdv9y4z70jiws9bwmw10vdn5sc8jdms53p4rgr4n4";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "5" "GeoIPCity.dat.xz"
    "1bq9kg6fsdsjssd3i6phq26n1px9jmljnq60gfsh8yb9s18hymfq";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "6" "GeoIPCityv6.dat.gz"
    "0anx3kppql6wzkpmkf7k1322g4ragb5hh96apl71n2lmwb33i148";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "2" "GeoIPASNum.dat.gz"
    "1w8k6a9590nbisajn8m0l6is44vzsf5xghpw7ld8l72brdm76nfi";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "3" "GeoIPASNumv6.dat.gz"
    "0xqhbbilp6h80zpc5dx5ng15fhpsi9wplimbfbd3rs0jx7gjd3jg";

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
