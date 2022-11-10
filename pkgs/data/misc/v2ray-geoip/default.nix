{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202211100058";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "6fcf11f003829b16b534a710a26549b741e81311";
    sha256 = "sha256-XlqfXRJa4xnw8lqC94TfRcXVW/8L7hrqENfC7A7rTpI=";
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
