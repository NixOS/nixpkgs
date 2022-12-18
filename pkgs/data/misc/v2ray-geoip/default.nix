{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202212150047";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "29c096b1285812a0a9a955b98ff2998c46f9b80a";
    sha256 = "sha256-44kP+4Bc7fwxNViWiKo7jLtUov+7k60v+7NF7CTkbjg=";
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
