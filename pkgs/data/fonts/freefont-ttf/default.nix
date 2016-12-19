{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "freefont-ttf-20120503";

  src = fetchurl {
    url = "mirror://gnu/freefont/${name}.zip";
    sha256 = "1bw9mrf5pqi2a29b7qw4nhhj566aqqmi28hkbn2a38c2pzqvm1bw";
  };

  buildInputs = [ unzip ];

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
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
