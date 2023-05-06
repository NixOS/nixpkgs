{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202305040042";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "ef62a770a54006accfdfa8e3e38e2bdf5997baf0";
    sha256 = "sha256-CThhxFVBIz9H0YiI3+fdy76kwq7bsMdONyRAvMQ5VrA=";
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
