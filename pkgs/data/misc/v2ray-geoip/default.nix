{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202211170054";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "e01c82114de0b2f3a2e8c80c78fc22e8fb71f68a";
    sha256 = "sha256-T94G1s3vTkh0pd2ByOpOwJDPn7geaHbnBB7w1K9qwps=";
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
