{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ttf-tw-moe";
  version = "2020-11-14";

  src = fetchzip {
    url = "https://github.com/Jiehong/TW-fonts/archive/${version}.zip";
    hash = "sha256-9gy8xO93ViIPmpg1du0DbXVCR2FowourLH8nP9d6HK0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.moe.gov.tw/";
    description = "Set of KAI and SONG fonts from the Ministry of Education of Taiwan";
    version = version;
    longDescription = ''
      Installs 2 TTF fonts: MOESongUN and TW-MOE-Std-Kai.
      Both are provided by the Ministry of Education of Taiwan; each character's shape
      closely follows the official recommendation, and can be used as for teaching purposes.
    '';
    license = licenses.cc-by-nd-30;
    maintainers = [ maintainers.jiehong ];
    platforms = platforms.all;
  };
}
