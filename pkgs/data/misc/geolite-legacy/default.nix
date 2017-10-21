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
    "04akk0jczvki8rdvz6z6v5s26ds0m27953lzvp3v0fsg7rl08q5n";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz"
    "0i0885vvj0s5sysyafvk8pc8gr3znh7gmiy8rp4iiai7qnbylb7y";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.gz"
    "1yqxqfndnsvqc3hrs0nm6nvs0wp8jh9phs0yzrn48rlb9agcb8gj";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
    "05grm006r723l9zm7pdmwwycc658ni858hcrcf5mysv0hmc3wqb2";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz"
    "1gpvsqvq9z9pg9zfn86i50fb481llfyn79r1jwddwfflp1qqfrrv";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz"
    "0nmhz82dn9clm5w2y6z861ifj7i761spy1p1zcam93046cdpqqaa";

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx fpletz ];
  };

  builder = ./builder.sh;
}
