{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "freefont-ttf-20100919";

  src = fetchurl {
    url = "mirror://gnu/freefont/${name}.tar.gz";
    sha256 = "1q3h5jp1mbdkinkwxy0lfd0a1q7azlbagraydlzaa2ng82836wg4";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
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

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
