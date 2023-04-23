{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202304200041";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "7869655f0a2c9fd81d04e091b1c2657029b6e1f9";
    sha256 = "sha256-pgQU8gLErC9zo/GtwxHC2+4svFsxkgceV3IZPovVMo4=";
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
