{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202210060105";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "0bb2420d643555aa19b21f3c06b517a7c14826b6";
    sha256 = "sha256-5vr7iO2vny9yalJblBVgNwupEQ9w3LZXM+VKb4xSVD0=";
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
