{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202305180042";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "1addec5dde6df338d37f43ddc7e760b03fd9f6a2";
    sha256 = "sha256-c1BCbqGMvzqz3NKs1J4qD5vhagz0BEnnBG5BmvEy9W0=";
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
