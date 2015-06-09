{ stdenv, fetchurl }:

let
  fetchDB = name: sha256: fetchurl {
    inherit sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${name}";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2015-06-03";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB "GeoLiteCountry/GeoIP.dat.gz"
    "1cd25xsw214bdmc657q3a1dcivjnh6ravdsgia2w7q8bq8g61yfp";
  srcGeoIPv6 = fetchDB "GeoIPv6.dat.gz"
    "1vi82p41vas18yp17yk236pn1xamsi9662aav79fa0hm43i3ydx3";
  srcGeoLiteCity = fetchDB "GeoLiteCity.dat.xz"
    "1z87ng2a2zmqnvxhcmapnarc9w2ycb18vpivvzx893y7fh39h34s";
  srcGeoLiteCityv6 = fetchDB "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
    "0xjzg76vdsayxyy1yyw64w781vad4c9nbhw61slh2qmazdr360g9";
  srcGeoIPASNum = fetchDB "asnum/GeoIPASNum.dat.gz"
    "0zccfd1wsny3n1f3wgkb071pp6z01nmk0p6nngha0gwnywchvbx4";
  srcGeoIPASNumv6 = fetchDB "asnum/GeoIPASNumv6.dat.gz"
    "0asnmmirridiy57zm0kccb7g8h7ndliswfv3yfk7zm7dk98njnxs";

  meta = with stdenv.lib; {
    inherit version;
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
