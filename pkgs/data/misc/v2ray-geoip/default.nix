{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202112300030";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "570a09062b1b6dbd3b8cb1785c0ce4a0ed3c50f4";
    sha256 = "sha256-YGKHruyVShFrMbE0eXzb2Qp3BMfM+4SLaK8pqR2sloM=";
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
