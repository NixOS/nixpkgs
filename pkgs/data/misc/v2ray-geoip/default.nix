{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202203170039";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "0b5c94c368dc5f70ebf995e87188aa8f40d45489";
    sha256 = "sha256-iaqU6CkrewICONps43nbZaUiM2aahSwfSD5bZz1P4Zc=";
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
