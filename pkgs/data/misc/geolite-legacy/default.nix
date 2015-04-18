{ stdenv, fetchurl }:

# Annoyingly, these files are updated without a change in URL. This means that
# builds will start failing every month or so, until the hashes are updated.
let version = "2015-03-26"; in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchurl {
    url = https://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz;
    sha256 = "01xw896n9wcm1pv7sixfbh4gv6isl6m1i6lwag1c2bbcx6ci1zvr";
  };
  srcGeoIPv6 = fetchurl {
    url = https://geolite.maxmind.com/download/geoip/database/GeoIPv6.dat.gz;
    sha256 = "07l10hd7fkgk1nbw5gx4hjp61kdqqgri97fidn78dlk837rb02d0";
  };
  srcGeoLiteCity = fetchurl {
    url = https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz;
    sha256 = "1xqjyz9xnga3dvhj0f38hf78wv781jflvqkxm6qni3sj781nfr4a";
  };
  srcGeoLiteCityv6 = fetchurl {
    url = https://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz;
    sha256 = "03s41ffc5a13qy5kgx8jqya97jkw2qlvdkak98hab7xs0i17z9pd";
  };
  srcGeoIPASNum = fetchurl {
    url = https://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz;
    sha256 = "1h766l8dsfgzlrz0q76877xksaf5qf91nwnkqwb6zl1gkczbwy6p";
  };
  srcGeoIPASNumv6 = fetchurl {
    url = https://download.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz;
    sha256 = "0dwi9b3amfpmpkknf9ipz2r8aq05gn1j2zlvanwwah3ib5cgva9d";
  };

  meta = with stdenv.lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = https://geolite.maxmind.com/download/geoip;
    license = with licenses; cc-by-sa-30;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  builder = ./builder.sh;
}
