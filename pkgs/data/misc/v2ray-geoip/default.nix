{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202210130107";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "becf974734e41542c356a0c0ae21a619c476d500";
    sha256 = "sha256-IF7mcyiZc4CTFWSflxQBH8Z9NloCcsCymOhU85GaoEg=";
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
