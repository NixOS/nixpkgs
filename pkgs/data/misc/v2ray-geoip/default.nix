{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202203100039";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "564c2c8de36d3680a1d5f209d6bb05e4f3f70dfc";
    sha256 = "sha256-JPpzIppgKQox8T6VC/kzhpLy+YAcuHdH5L6zqciOXow=";
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
