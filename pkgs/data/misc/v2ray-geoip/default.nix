{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202304060040";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "8d65f1d075e077ffc5cdae297795c65f12b37159";
    sha256 = "sha256-RGDHYgecNDcVwa9yXMgjml72QLf14oHtDGCjXOjeF5A=";
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
