{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "freefont-ttf-20090104";

  src = fetchurl {
    url = "mirror://gnu/freefont/${name}.tar.gz";
    sha256 = "13k3gm31wqa5ch14rmd3zpapckaif9bv4x82x72xaqn3n1j733ib";
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
    license = "GPLv3+";
  };
}
