{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202304130041";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "0d55816db7bb2489333f38d05e30500a9730bd0b";
    sha256 = "sha256-W/Fcx282YWmxq+kVm5OxgC5a4mJhe0s0/NTROPJGGrw=";
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
