{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202305110042";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "d3e53c0849b499829dfb97af7e10552257277d2e";
    sha256 = "sha256-jCktxDGMkRiG8tiNx27V9s1LLqaitWDBAB063+eLwmg=";
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
