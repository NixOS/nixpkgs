{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202209080101";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "2e77e5d149f0a8f9c284333b206d0f017b0b66ef";
    sha256 = "sha256-vkWRBSwLpCqZWMlfwOyPWn2MF+/lG+VXnSrDCSR+dak=";
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
