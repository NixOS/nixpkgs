{stdenv, fetchzip}:

fetchzip rec {
  name = "freefont-ttf-20120503";

  url = "mirror://gnu/freefont/${name}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "0h0x2hhr7kvjiycf7fv800xxwa6hcpiz54bqx06wsqc7z61iklvd";

  meta = {
    description = "GNU Free UCS Outline Fonts";
    longDescription = ''
      The GNU Freefont project aims to provide a set of free outline
      (PostScript Type0, TrueType, OpenType...) fonts covering the ISO
      10646/Unicode UCS (Universal Character Set).
    '';
    homepage = https://www.gnu.org/software/freefont/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
