{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202212010055";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "350625ecfeec1300d541cc618fddb1922d5d2365";
    sha256 = "sha256-EnqINoG6nB1m1K7mp0UBW3K2MDuaE7Z84wfCJBFwweU=";
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
