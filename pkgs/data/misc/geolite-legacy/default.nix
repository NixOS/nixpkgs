{ stdenv, fetchurl }:

let
  fetchDB = src: name: sha256: fetchurl {
    inherit name sha256;
    url = "https://geolite.maxmind.com/download/geoip/database/${src}";
  };

  # Annoyingly, these files are updated without a change in URL. This means that
  # builds will start failing every month or so, until the hashes are updated.
  version = "2015-07-30";
in
stdenv.mkDerivation {
  name = "geolite-legacy-${version}";

  srcGeoIP = fetchDB
    "GeoLiteCountry/GeoIP.dat.gz" "GeoIP.dat.gz"
    "1yacbh8qcakmnpipscdh99vmsm0874g2gkq8gp8hjgkgi0zvcsnz";
  srcGeoIPv6 = fetchDB
    "GeoIPv6.dat.gz" "GeoIPv6.dat.gz"
    "038ll8142svhyffxxrg0isrr16rjbz0cnkhd14mck77f1v8z01y5";
  srcGeoLiteCity = fetchDB
    "GeoLiteCity.dat.xz" "GeoIPCity.dat.xz"
    "0x5ihg7qikzc195nix9r0izvbdnj4hy4rznvaxk56rf8yqcigdyv";
  srcGeoLiteCityv6 = fetchDB
    "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz" "GeoIPCityv6.dat.gz"
    "0j5dq06pjrh6d94wczsg6qdys4v164nvp2a7qqrg8w4knh94qp6n";
  srcGeoIPASNum = fetchDB
    "asnum/GeoIPASNum.dat.gz" "GeoIPASNum.dat.gz"
    "16lfazhyhwmh8fyd7pxzwxp5sxszbqw4xdx3avv78hglhyb2ijkw";
  srcGeoIPASNumv6 = fetchDB
    "asnum/GeoIPASNumv6.dat.gz" "GeoIPASNumv6.dat.gz"
    "16jd6f2pwy8616jb78x8j6zda7h0p1bp786y86rq3ipgcw6g0jgn";

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
