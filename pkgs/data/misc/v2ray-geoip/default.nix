{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202201130034";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "68254f88c97e6ac1ec587bcf6491902ccf29a447";
    sha256 = "sha256-fpwJpXampcHiP68ABcEW5HawPuLwbcmNOY0aiFSzwcs=";
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
