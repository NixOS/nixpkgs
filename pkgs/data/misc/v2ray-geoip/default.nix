{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202202170030";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "ebc49c1ccbe7f267778ab42dbfa01d7ff8a5241c";
    sha256 = "sha256-CxV7jKNeaSW7lVBKKr7Ih2XAehnFcapkyDogd5V32Zk=";
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
