{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202302230047";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "8ae031e49fecaa0ef8d3e2501741cf2cb12e3eac";
    sha256 = "sha256-5p3u9/v32bMEhAXgu/v5ooiis0Nt4peVPeCA9o0AKv8=";
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
