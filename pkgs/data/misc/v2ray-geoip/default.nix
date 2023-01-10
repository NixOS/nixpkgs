{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202301050046";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "6bb07558ac223b3decdff985d5737f4384b34238";
    sha256 = "sha256-KXLIIs1W+8TC2GtW3m/YA5WQ13Pq5kxC5Zc9jDzW/tU=";
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
