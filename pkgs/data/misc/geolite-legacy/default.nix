{ stdenv, fetchurl }:

let
  fetchDB = name: sha256: fetchurl {
    inherit sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${name}";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2015-05-07";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB "GeoLiteCountry/GeoIP.dat.gz"
    "15p8is7jml8xsy7a8afsjq7q20pkisbk5b7nj465ljaz5svq6rgv";
  srcGeoIPv6 = fetchDB "GeoIPv6.dat.gz"
    "0apiypf500k9k89x6zm1109gw6j9xs83c80iyl17rxlik1hhqf8g";
  srcGeoLiteCity = fetchDB "GeoLiteCity.dat.xz"
    "12j44586jmvk1jnxs345lgdgl9izn51xgh1m2jm7lklsyw13b2nk";
  srcGeoLiteCityv6 = fetchDB "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
    "1jlxd60l7ic7md0d93fhiyd2vqms1fcirp6wkm0glh347j64srsb";
  srcGeoIPASNum = fetchDB "asnum/GeoIPASNum.dat.gz"
    "1y5b68s1giw01vw98c99qdhjiaxx6l4hrc2mx4rdaja46zic4maz";
  srcGeoIPASNumv6 = fetchDB "asnum/GeoIPASNumv6.dat.gz"
    "0crl31yc11w4jzgvbr9pgqd7x6ivpsgsip19s1g5xl71qbpmmjxm";

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
