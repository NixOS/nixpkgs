{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "zpix-pixel-font";
  version = "3.3.0";

  srcs = {
    bdf = fetchurl {
      name = "zpix-pixel-font.bdf";
      url = "https://github.com/SolidZORO/zpix-pixel-font/releases/download/v${version}/zpix.bdf";
      hash = "sha256-CImzIUESOnxZnOy6nsAh/PCcvZubO7GK1fRtKID/qzY=";
    };
    ttf = fetchurl {
      name = "zpix-pixel-font.ttf";
      url = "https://github.com/SolidZORO/zpix-pixel-font/releases/download/v${version}/zpix.ttf";
      hash = "sha256-pnkX2Uu1l6y987/hz5cEfMPhzdODnSHaGI41zAc36Cg=";
    };
  };

  dontUnpack = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 ''${srcs[bdf]} $out/share/fonts/misc/zpix.bdf
    install -Dm444 ''${srcs[ttf]} $out/share/fonts/truetype/zpix.ttf
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Pixel font supporting multiple languages like English, Chinese and Japanese";
    homepage = "https://github.com/SolidZORO/zpix-pixel-font/";
    changelog = "https://github.com/SolidZORO/zpix-pixel-font/blob/master/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.adriangl ];
    platforms = lib.platforms.all;
  };
}
