{
  lib,
  stdenv,
  fetchurl,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "geolite-legacy";
  version = "20230901";

  # We use Arch Linux package as a snapshot, because upstream database is updated in-place.
  geoip = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database/geoip-database-${version}-1-any.pkg.tar.zst";
    sha256 = "sha256-H6tv0OEf04TvbhbWsm5vwq+lBj4GSyOezd258VOT8yQ=";
  };

  extra = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database-extra/geoip-database-extra-${version}-1-any.pkg.tar.zst";
    sha256 = "sha256-Zb5m5TLJ1vcPKypZ3NliaL9oluz97ukTVGlOehuzyPU=";
  };

  nativeBuildInputs = [ zstd ];

  buildCommand = ''
    tar -xaf ${geoip}
    tar -xaf ${extra}
    mkdir -p $out/share
    mv usr/share/GeoIP $out/share
  '';

  meta = with lib; {
    description = "GeoLite Legacy IP geolocation databases";
    homepage = "https://mailfud.org/geoip-legacy/";
    license = licenses.cc-by-sa-40;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
