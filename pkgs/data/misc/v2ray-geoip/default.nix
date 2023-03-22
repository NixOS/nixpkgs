{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202303160048";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "ca1a04c113293b00434d9d60e24aee17e660f4a6";
    sha256 = "sha256-YhFYrVN6ZQQeuM8ZCeFRmID/NTsI75oe4c51lOfb18s=";
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
