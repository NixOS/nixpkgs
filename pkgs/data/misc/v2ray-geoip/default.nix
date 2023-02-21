{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202302200325";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "c642604d56dbe9b426871e3a47e18eba3d3d3850";
    sha256 = "sha256-tsDoz/2b0InjLWfgi2Jcs8BpscQ0SFA6+tVZIw6JQGA=";
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
