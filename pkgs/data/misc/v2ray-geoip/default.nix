{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202207070057";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "cbabee03cf7b7b60b1167a8a14ba1eba9d9dbb77";
    sha256 = "sha256-bWhsV7+aj75nd8NDeb5D5UjvCChhtXq9lpkaZN41wDk=";
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
