{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202205260055";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "96f4639373709f7560ccaf374d1ff008781aa324";
    sha256 = "sha256-aFTLeYr+JishhJ2AhGMrD02fKxci2rREkh8HN9HtXLs=";
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
