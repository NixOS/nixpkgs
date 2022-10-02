{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "clash-geoip";
  version = "20220912";

  src = ./.;

  data = fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/${version}/Country.mmdb";
    sha256 = "sha256-YIQjuWbizheEE9kgL+hBS1GAGf2PbpaW5mu/lim9Q9A";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/clash
    install -Dm 0644 $data -D $out/etc/clash/Country.mmdb
    runHook postInstall
  '';

  meta = with lib; {
    description = "A GeoLite2 data created by MaxMind";
    homepage = "https://github.com/Dreamacro/maxmind-geoip";
    license = licenses.unfree;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
