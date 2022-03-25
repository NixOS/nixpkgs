{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202203240042";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "d7ff77f883216595a4b6674e9507f305195dcda3";
    sha256 = "sha256-wSm24nXz4QIM8e7Z8d08NjluLaBWEdl09FNAL3GR9so=";
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
