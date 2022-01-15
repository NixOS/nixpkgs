{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202201060033";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "57f0e64ece0582314958c027198b8e50daa353d2";
    sha256 = "sha256-RG7sLp9u8k1U5XVFcwAF57UcvwhF3pFKCFLLJ2x7q00=";
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
