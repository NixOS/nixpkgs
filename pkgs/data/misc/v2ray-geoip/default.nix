{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202210270100";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "7558586fefca29c5d1705777187677fd8a4c4e6f";
    sha256 = "sha256-8UKcmkaRe51X4JgQ5pqPE46BnVF0AlXETD/Pliwx9xk=";
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
