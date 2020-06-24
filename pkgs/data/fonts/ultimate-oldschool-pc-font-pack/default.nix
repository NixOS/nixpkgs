{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ultimate-oldschool-pc-font-pack";
  version = "1.0";

  src = fetchzip {
    url = "https://int10h.org/oldschool-pc-fonts/download/ultimate_oldschool_pc_font_pack_v${version}.zip";
    sha256 = "0mxdm1r3v9qm6vsag673yqa61kwqsz73f2dkj8nhjwmprq688lg1";
    stripRoot = false;
  };

  meta = with lib; {
    description = "The Ultimate Oldschool PC Font Pack (TTF Fonts)";
    homepage = "https://int10h.org/oldschool-pc-fonts/";
    license = licenses.cc-by-sa-40;
    maintainers = [ maintainers.endgame ];
  };
}
