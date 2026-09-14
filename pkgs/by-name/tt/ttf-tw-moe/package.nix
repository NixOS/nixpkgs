{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ttf-tw-moe";
  version = "2026-05-11";

  src = fetchzip {
    url = "https://github.com/Jiehong/TW-fonts/archive/${version}.zip";
    hash = "sha256-IlAYR0/wxL+tOI7X4t5eypTMqxMCLpTp9jCM7512SNk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.moe.gov.tw/";
    description = "Set of KAI and SONG fonts from the Ministry of Education of Taiwan";
    version = version;
    longDescription = ''
      Installs 2 TTF fonts: MOESongUN and TW-MOE-Std-Kai.
      Both are provided by the Ministry of Education of Taiwan; each character's shape
      closely follows the official recommendation, and can be used as for teaching purposes.
    '';
    license = lib.licenses.cc-by-nd-30;
    maintainers = [ lib.maintainers.jiehong ];
    platforms = lib.platforms.all;
  };
}
