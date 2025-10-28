{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ultimate-oldschool-pc-font-pack";
  version = "2.2";

  src = fetchzip {
    url = "https://int10h.org/oldschool-pc-fonts/download/oldschool_pc_font_pack_v${version}_linux.zip";
    stripRoot = false;
    hash = "sha256-54U8tZzvivTSOgmGesj9QbIgkSTm9w4quMhsuEc0Xy4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp */*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ultimate Oldschool PC Font Pack (TTF Fonts)";
    homepage = "https://int10h.org/oldschool-pc-fonts/";
    changelog = "https://int10h.org/oldschool-pc-fonts/readme/#history";
    license = licenses.cc-by-sa-40;
    maintainers = [ maintainers.endgame ];
  };
}
