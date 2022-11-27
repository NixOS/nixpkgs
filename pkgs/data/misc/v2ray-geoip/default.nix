{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202211240054";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "1887d855ed4b4b92999d3afecf71f43358029369";
    sha256 = "sha256-WozqLA/akUF7T0LyR/nQkTxuZPNCpYarOQG5zQwGAMk=";
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
