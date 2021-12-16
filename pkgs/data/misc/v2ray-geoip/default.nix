{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202112090029";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "97f4acb31d926ae31bb3cdc5c8948d8dcdddca79";
    sha256 = "sha256-kYMp/D7xVpBTu35YXq45bR2XebpVOW57UAc7H/6px/U=";
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
