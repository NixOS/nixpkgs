{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "mno16";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/sevmeyer/${pname}/releases/download/${version}/${pname}-${version}.zip";
    stripRoot = false;
    hash = "sha256-xJQ9V7GlGUTEeYhqYFl/SemS6iqV0eW85YOn/tLgA+M=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp fonts/*.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "minimalist monospaced font";
    homepage = "https://sev.dev/fonts/mno16";
    license = licenses.cc0;
  };
}
