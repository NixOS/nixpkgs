{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "ankacoder-condensed";
  version = "1.100";

  src = fetchzip {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/anka-coder-fonts/AnkaCoderCondensed.${version}.zip";
    stripRoot = false;
    hash = "sha256-NHrkV4Sb7i+DC4e4lToEYzah3pI+sKyYf2rGbhWj7iY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Anka/Coder Condensed font";
    homepage = "https://code.google.com/archive/p/anka-coder-fonts";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}

