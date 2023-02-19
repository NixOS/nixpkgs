{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202302160443";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "f8fbab498f52848317db703f57f0c839e81cd587";
    sha256 = "sha256-9LZxVNhigy2cO41d8nZtFrfDoCjJTdzrGUZpmjcpje8=";
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
