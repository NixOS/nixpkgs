{ lib, fetchzip }:

fetchzip rec {
  pname = "freefont-ttf";
  version = "20120503";

  url = "mirror://gnu/freefont/freefont-ttf-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf $out/share/fonts/truetype
    find $out -maxdepth 1 ! -type d -exec rm {} +
  '';

  sha256 = "sha256-bdMZg/mHYc0N6HiR8uNl0CjeOwBou+OYj3LPkyEUHUA=";

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
