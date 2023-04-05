{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202303272340";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "0473ff6f84b7bb926af68238489d05f683b87e1d";
    sha256 = "sha256-76SsWF3jOi+I975C9WNVMGrLqvgtdM48n9bV0jevx3Q=";
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
