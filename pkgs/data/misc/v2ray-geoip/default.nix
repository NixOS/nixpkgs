{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202209170841";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "9487b31412243e602ee3332ff3cce63a15906733";
    sha256 = "sha256-gKzrPBiifC2Lg050tFJynFd6DZ4vzSoPB6wbR4OzMFQ=";
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
