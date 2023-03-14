{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202303090050";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "e1cd759a93ff7e65cd8099ee628803a83ab8cae0";
    sha256 = "sha256-m6TYu6cT57MDOXXfI76ufGDWJYmxjtVZg5vSToM8btE=";
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
