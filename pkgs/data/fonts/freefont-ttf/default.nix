{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "freefont-ttf";
  version = "20120503";

  src = fetchzip {
    url = "mirror://gnu/freefont/${pname}-${version}.zip";
    sha256 = "02rdzifgz46hfibppn6kfwx1w41410dsirvmm62sjd237701hvpf";
    stripRoot = false;
  };

  meta = {
    description = "GNU Free UCS Outline Fonts";
    longDescription = ''
      The GNU Freefont project aims to provide a set of free outline
      (PostScript Type0, TrueType, OpenType...) fonts covering the ISO
      10646/Unicode UCS (Universal Character Set).
    '';
    homepage = "https://www.gnu.org/software/freefont/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [];
  };
}
