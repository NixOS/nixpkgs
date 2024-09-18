{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "last-resort";
  version = "16.000";

  src = fetchurl {
    url = "https://github.com/unicode-org/last-resort-font/releases/download/${version}/LastResortHE-Regular.ttf";
    hash = "sha256-YMSKv8BenyujNZnE3LpAEF0eznHTdh8LJvdaOLWxeJU=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D -m 0644 $src $out/share/fonts/truetype/LastResortHE-Regular.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fallback font of last resort";
    homepage = "https://github.com/unicode-org/last-resort-font";
    license = licenses.ofl;
    maintainers = [ ];
  };
}
