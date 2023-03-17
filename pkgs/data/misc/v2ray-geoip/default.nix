{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202303020053";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "c002daa9332a673ce2fabe61eb9c45dc6a54f3fa";
    sha256 = "sha256-Pfny59HitidyXgXaI/1V3UNdM18X0+vVCyKP4qkL1rY=";
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
