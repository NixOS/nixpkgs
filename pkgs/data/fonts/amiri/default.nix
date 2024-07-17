{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "amiri";
  version = "1.000";

  src = fetchzip {
    url = "https://github.com/alif-type/amiri/releases/download/${version}/Amiri-${version}.zip";
    hash = "sha256-WXxKLYIIKe01WWZrI1aLOv65wRgn7aqHl6Codf4foVw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype/
    mkdir -p $out/share/doc/${pname}-${version}
    mv {*.html,*.txt,*.md} $out/share/doc/${pname}-${version}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A classical Arabic typeface in Naskh style";
    homepage = "https://www.amirifont.org/";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}
