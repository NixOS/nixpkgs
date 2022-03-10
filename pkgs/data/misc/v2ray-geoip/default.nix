{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202203020509";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "9dce4df2c1f409bad67f579910a4edf522251e7b";
    sha256 = "sha256-fR0lzvVQjWA3KbzLhuvoB15Z+7RAv34Wf5W7KRZ//QA=";
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
