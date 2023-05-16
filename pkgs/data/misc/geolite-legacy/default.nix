{ lib, stdenv, fetchurl, zstd }:

stdenv.mkDerivation rec {
  pname = "geolite-legacy";
<<<<<<< HEAD
  version = "20230901";
=======
  version = "20220621";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # We use Arch Linux package as a snapshot, because upstream database is updated in-place.
  geoip = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database/geoip-database-${version}-1-any.pkg.tar.zst";
<<<<<<< HEAD
    sha256 = "sha256-H6tv0OEf04TvbhbWsm5vwq+lBj4GSyOezd258VOT8yQ=";
=======
    sha256 = "sha256-dmj3EtdAYVBcRnmHGNjBVyDQIKtVoubNs07zYVH9HVM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  extra = fetchurl {
    url = "https://archive.archlinux.org/packages/g/geoip-database-extra/geoip-database-extra-${version}-1-any.pkg.tar.zst";
<<<<<<< HEAD
    sha256 = "sha256-Zb5m5TLJ1vcPKypZ3NliaL9oluz97ukTVGlOehuzyPU=";
=======
    sha256 = "sha256-jViHQ+w9SEqFCbWf4KtNiTdWXT0RuCTjZ9dus0a3F0k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
