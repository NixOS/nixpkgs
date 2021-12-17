{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202112160030";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "4d86284b91a444c2ca989207f8f08a1c8798c95c";
    sha256 = "sha256-pv+oZVMROr7gyGcv60jIP8INt4vBAnUJT0FJNNn+Czc=";
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
