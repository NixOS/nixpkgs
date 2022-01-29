{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202201270031";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "236a5edc951685cf11d5fcbd08d82d74bd425f92";
    sha256 = "sha256-y2hVSlfUwbbKpd2O8VBwTEL/djhXjd2XhBbDlmmqJCc=";
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
