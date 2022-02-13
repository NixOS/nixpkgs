{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202202100032";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "0a16dba825e420425786ff74f51a6bb881a62624";
    sha256 = "sha256-M3DitRNhvPh4AOocnG6omiQAPKgWziAcN4uO42/7BNE=";
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
