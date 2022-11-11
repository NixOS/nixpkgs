{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202211030059";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "b7d16c8aea9bbe2555fe4aabddd1fb86f9785229";
    sha256 = "sha256-1WxqD9a0uJY+/DiFwESkEceN2EJvDl5qhLg4oEs5uSA=";
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
