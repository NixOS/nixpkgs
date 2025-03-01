{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "abnes-font";
  version = "1.0.0";

  src = fetchzip {
    url = "https://fonts.resourceboy.com/file/rb-fonts/2024/08/58962/Abnes-Font.zip";
    hash = "sha256-x/AhooCW0+JF66kNaY96iB3+HpAd+l6QJ3bDZxf1xXk=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src/*.ttf -t $out/share/fonts/truetype
    install -Dm644 $src/*.otf -t $out/share/fonts/opentype

    cp -p $src/Misc/License.txt $out/

    runHook postInstall
  '';

  meta = {
    description = "Abnes Font made by 177 Studio free only for indivduals";
    homepage = "https://177studio.com/product/abnes-elegant-sans-serif-font/";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      DrVoidest
    ];
  };
}
