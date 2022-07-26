{ lib, stdenv, fetchurl, zstd }:

stdenv.mkDerivation {
  pname = "geolite-legacy";
  version = "2022-01-25";

  # We use Arch Linux package as a snapshot, because upstream database is updated in-place.
  geoip = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database/geoip-database-20220125-1-any.pkg.tar.zst";
    sha256 = "sha256-ieuLpllJTHYu28UXBGfDWbnr9Ei8pGnos+RPWDsAGcM=";
  };

  extra = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database-extra/geoip-database-extra-20220125-1-any.pkg.tar.zst";
    sha256 = "sha256-xrTnuJvuvtvn+uIARtbuJUlHco3Q+9BXLljt35V3ip0=";
  };

  nativeBuildInputs = [ zstd ];

  buildCommand = ''
    tar -xaf "$geoip"
    tar -xaf "$extra"
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
