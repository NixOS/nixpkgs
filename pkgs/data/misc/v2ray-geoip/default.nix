{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202306010100";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "d8faa6ba0754c083a89898610942d1d1d978ef7f";
    sha256 = "sha256-Aumk+YPsxZl3F/DQv6w0rE5f5hduLNYApCKQIvRUSIw=";
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
