{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202304270044";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "015e040dbd71ec79f57555d9c2721326e4254b34";
    sha256 = "sha256-yY+mEsnc4x6zgslpu8755tGt7I17xBB1RXdAzSLtf2U=";
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
