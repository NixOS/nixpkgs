{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202209220104";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "4eaa41ebcfc2aafaa5b363b8efdd867c53e3435b";
    sha256 = "sha256-B0a6Zqd9WmlwBY6Kj0ZKNjZXzZWaNhRL0tLT0PM+gGA=";
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
