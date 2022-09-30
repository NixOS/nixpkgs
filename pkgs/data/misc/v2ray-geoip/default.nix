{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202209290111";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "1aa11a6dd94b708175a81b12037486459fa090a8";
    sha256 = "sha256-CVze/QyoBKZmd+U8bfjxr+u8W95W+fs9+mAdPgyIpg4=";
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
