{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "v2ray-geoip";
  version = "202208040058";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "geoip";
    rev = "97174fe0eeb28838b0e5e805687d230df773e661";
    sha256 = "sha256-hodJ4HQHbv9voSS847pAHd3YSmfkV7fKyJhEUApVN+w=";
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
