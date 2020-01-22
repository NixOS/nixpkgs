{ lib, fetchzip }:

let
  version = "1.0";
in
fetchzip {
  name = "ultimate-oldschool-pc-font-pack-${version}";
  url = "https://int10h.org/oldschool-pc-fonts/download/ultimate_oldschool_pc_font_pack_v${version}.zip";
  sha256 = "0hid4dgqfy2w26734vcw2rxmpacd9vd1r2qpdr9ww1n3kgc92k9y";

  postFetch= ''
    mkdir -p $out/share/fonts/truetype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "The Ultimate Oldschool PC Font Pack (TTF Fonts)";
    homepage = "https://int10h.org/oldschool-pc-fonts/";
    license = licenses.cc-by-sa-40;
    maintainers = [ maintainers.endgame ];
  };
}
