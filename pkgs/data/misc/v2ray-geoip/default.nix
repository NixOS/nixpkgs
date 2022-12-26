{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202212220043";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "4a54320369805321b90c7c5ca4cdda4f12bdd295";
    sha256 = "sha256-PFbjzzjeCKL9aak45B+R5Y+H3fTBzdXpyEvvEEdInbQ=";
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
