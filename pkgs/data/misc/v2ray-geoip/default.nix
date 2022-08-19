{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202208180100";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "005c33be4dd95339596ddd5ce792e8f97dd168a3";
    sha256 = "sha256-KvEmgtbelZOauE2WBTzJkwJkaUVW2x8ezgmTE+Gbwu8=";
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
