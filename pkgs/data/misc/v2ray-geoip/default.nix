{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202301190046";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "83ea735314fbc2c3404cb4b9aa044b476e67bc8b";
    sha256 = "sha256-8u2xhpoA6BH9e+kgDwxPsjD4RSuUw05h39aUo7ivM3U=";
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
