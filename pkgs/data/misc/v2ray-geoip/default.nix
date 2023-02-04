{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202302020047";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "9ab244ed78fea88a1ce5bf789fb31bbcd81e8d17";
    sha256 = "sha256-2NYuvzOU0W3qZqWZMr3rTNqX+0rH3fhIr1zCD5dSdWc=";
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
