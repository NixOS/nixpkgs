{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202305250042";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "e63c89ce477577a720eda422c6c04ba241a36021";
    sha256 = "sha256-Jv/QZyoMe/kSz/hdlwhfgQzCJGOH6Oypn6HU1SRPTis=";
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
