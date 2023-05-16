{ lib, stdenvNoCC, fetchurl, nix-update-script }:

stdenvNoCC.mkDerivation rec {
  pname = "clash-geoip";
<<<<<<< HEAD
  version = "20230812";

  src = fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/${version}/Country.mmdb";
    sha256 = "sha256-yO8zSQjNYGxaSXcOhFOIE4HsiMnCm3ZVYfVZg5xO96s=";
=======
  version = "20230312";

  src = fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/${version}/Country.mmdb";
    sha256 = "sha256-Y/glz6HUfjox9Mn+gPzA8+tUHqV/KkIInUn4SyajUiE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/clash
    install -Dm 0644 $src -D $out/etc/clash/Country.mmdb
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A GeoLite2 data created by MaxMind";
    homepage = "https://github.com/Dreamacro/maxmind-geoip";
    license = licenses.unfree;
    maintainers = [];
<<<<<<< HEAD
    platforms = platforms.all;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
