{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202212080044";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "b8fc720b187e59a55609b2db8cf971a6c938be83";
    sha256 = "sha256-Fg+r23V5gs9wQKfgH/xkUqJvSOc8daaWLuNiDWD2Nz8=";
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
