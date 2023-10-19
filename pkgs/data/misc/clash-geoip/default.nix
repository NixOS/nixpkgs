{ lib, stdenvNoCC, fetchurl, nix-update-script }:

stdenvNoCC.mkDerivation rec {
  pname = "clash-geoip";
  version = "20230912";

  src = fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/${version}/Country.mmdb";
    sha256 = "sha256-MyNlgsa+8OS7vkMq74KKmUVzBhmDpF4ED2Xdgl3GIS4=";
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
    platforms = platforms.all;
  };
}
