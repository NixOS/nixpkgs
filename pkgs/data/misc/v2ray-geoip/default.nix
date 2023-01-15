{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202301120046";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "c308361f47373772d1a3b9d486cd7dded7165d8e";
    sha256 = "sha256-GhCEsMDeMapWpJckMWS+3azuNjMdiN4cjDyq8aSJINA=";
  };

  installPhase = ''
    runHook preInstall
    install -m 0644 geoip.dat -D $out/share/v2ray/geoip.dat
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "GeoIP for V2Ray";
    homepage = "https://github.com/v2fly/geoip";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ nickcao ];
  };
}
