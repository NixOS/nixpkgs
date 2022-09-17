{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202209150105";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "6666b85fc48179414d59613cdfd6f83354f778bc";
    sha256 = "sha256-iBQvfVvfTG8zQdoTGOFxME0tr/YWCVxjXFQhP/zmRVU=";
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
