{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202203310042";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "eb0fc69f57bdceef077e38d4f4f57c114411bd76";
    sha256 = "sha256-CSABX+329/WgaXy144JgYsr3OesI69vCfew5qxz5jMY=";
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
