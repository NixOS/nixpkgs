{ stdenv, fetchurl }:

let
  fetchDB = src: name: sha256: fetchurl {
    inherit name sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2015-10-09";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "GeoIP.dat.gz"
    "066j1mnpzfyd5cp0knvg13v01fdvgv32ggvab0xwyh1pa0c14dv4";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "GeoIPv6.dat.gz"
    "1q5vgk522wq5ybhbw86zk8njgg611kc46a22vkrp08vklbni3akz";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "GeoIPCity.dat.xz"
    "09w7vs13xzji574bykggh8cph992zc4yajvhjh4qrvwrxjmjilw3";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "GeoIPCityv6.dat.gz"
    "0jdgfcy90mk7q25rhb8ymnddkskmp2cmyzmbjr3ij0zvbbpzxl4i";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "GeoIPASNum.dat.gz"
    "05j2nygvb7xi4s636dik12vgrdi37q5fdv5k3liqgswf9z0msz81";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "GeoIPASNumv6.dat.gz"
    "17s7pcqmfd9xvq0hd7g7nh62sjayl24w04ifm39snrq2a32l667n";

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
