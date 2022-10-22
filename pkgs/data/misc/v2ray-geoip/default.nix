{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202210200105";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "a9409c3b7c6a788e7be62c9b92a24d034f521603";
    sha256 = "sha256-CuR1xeCcuzxMMgstyjcdQKpU0n6AkA6X786LpUmANGE=";
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
