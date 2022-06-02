{ lib, fetchzip }:

let
  version = "2.2";
in
fetchzip {
  name = "ultimate-oldschool-pc-font-pack-${version}";
  url = "https://int10h.org/oldschool-pc-fonts/download/oldschool_pc_font_pack_v${version}_linux.zip";
  sha256 = "sha256-BOA2fMa2KT3Bkpvj/0DzrzuZbl3RARvNn4qbI/+dApU=";

  postFetch= ''
    mkdir -p $out/share/fonts/truetype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "The Ultimate Oldschool PC Font Pack (TTF Fonts)";
    homepage = "https://int10h.org/oldschool-pc-fonts/";
    changelog = "https://int10h.org/oldschool-pc-fonts/readme/#history";
    license = licenses.cc-by-sa-40;
    maintainers = [ maintainers.endgame ];
  };
}
