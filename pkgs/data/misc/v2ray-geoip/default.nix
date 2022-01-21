{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202201200035";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "8d388b019028fb6fa9f0756b745331ffb9eb7c03";
    sha256 = "sha256-ymXaDmmMucTuvJRqjJv6n22e7ONRt1awtOMABFJ+Y/w=";
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
