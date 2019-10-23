{ stdenv, fetchurl }:

let
  fetchDB = src: sha256: fetchurl {
    inherit sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };
in
stdenv.mkDerivation {
  pname = "geolite-legacy";
  version = "2017-12-02";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz"
    "1nggml11wzlanmzk6wbw2kla91fj8ggd9kh9yz42lnyckdlf5ac4";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz"
    "0w809xgmr5zi4fgm9q3lhrnh1vl62s49n737bhq4jplm5918ki50";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.gz"
    "0cibajsv5xdjpw1qfx22izm5azqcj0d7nvk39irgwflkim9jfjbs";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
    "1ldwbzgs64irfgb3kq3jp8fmhwmwqk713dr4kkdqlglrblr9hfkc";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz"
    "06qqs8qr8vxqwd80npz7n66k3bpc1vs7w43i2bb4k0di5yxnjwr9";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz"
    "1qyq4h8cja62giv6q1qqc502vsq53wzz1kx80mgvwngmycrxa21k";

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };

  builder = ./builder.sh;
}
