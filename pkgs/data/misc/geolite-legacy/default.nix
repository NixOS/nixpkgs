{ lib, stdenv, fetchurl, zstd }:

stdenv.mkDerivation rec {
  pname = "geolite-legacy";
  version = "20220621";

  # We use Arch Linux package as a snapshot, because upstream database is updated in-place.
  geoip = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database/geoip-database-${version}-1-any.pkg.tar.zst";
    sha256 = "sha256-dmj3EtdAYVBcRnmHGNjBVyDQIKtVoubNs07zYVH9HVM=";
  };

  extra = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database-extra/geoip-database-extra-${version}-1-any.pkg.tar.zst";
    sha256 = "sha256-jViHQ+w9SEqFCbWf4KtNiTdWXT0RuCTjZ9dus0a3F0k=";
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
