{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202301260045";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "dda29e7611d13ff6f580cf389a7b84194363f75c";
    sha256 = "sha256-9X9Oh4WFFpuRG1jQyQHTqNOCcW5f+uNOjH1iv1i6Je0=";
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
