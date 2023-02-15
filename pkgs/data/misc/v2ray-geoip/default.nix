{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202302081046";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "d85771a99440dd75294bfd9d00011307b7596d0d";
    sha256 = "sha256-gVL7koUG3BgY8HAYWa2fTwTJIE3svGUgauwI1jlA2/M=";
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
