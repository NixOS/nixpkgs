{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "freefont-ttf-20080323";
  src = fetchurl {
    url = "mirror://gnu/freefont/${name}.tar.gz";
    sha256 = "17wkasp5bgzw8n1dxpfcgj5zawfb743ff3cq24qh4brkyfrf2jkr";
  };

  installPhase = ''
    ensureDir $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "GNU Free UCS Outline Fonts";

    longDescription = ''
      The GNU Freefont project aims to provide a set of free outline
      (PostScript Type0, TrueType, OpenType...) fonts covering the ISO
      10646/Unicode UCS (Universal Character Set).
    '';

    homepage = http://www.gnu.org/software/freefont/;
    license = "GPLv2+";
  };
}
