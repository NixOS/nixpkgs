{stdenv, fetchgit, bdftopcf, mkfontdir, mkfontscale}:

stdenv.mkDerivation rec {
  date = "2015-06-07";
  name = "tewi-font-${date}";

  src = fetchgit {
    url = "https://github.com/lucy/tewi-font";
    rev = "ff930e66ae471da4fdc226ffe65fd1ccd13d4a69";
    sha256 = "0c7k847cp68w20frzsdknpss2cwv3lp970asyybv65jxyl2jz3iq";
  };

  buildInputs = [ bdftopcf mkfontdir mkfontscale ];
  buildPhase = ''
    for i in *.bdf; do
        bdftopcf -o ''${i/bdf/pcf} $i
    done

    gzip *.pcf
  '';

  installPhase = ''
    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  meta = with stdenv.lib; {
    description = "A nice bitmap font, readable even at small sizes";
    longDescription = ''
      Tewi is a bitmap font, readable even at very small font sizes. This is
      particularily useful while programming, to fit a lot of code on your
      screen.
    '';
    homepage = https://github.com/lucy/tewi-font;
    license = {
      fullName = "GNU General Public License with a font exception";
      url = "https://www.gnu.org/licenses/gpl-faq.html#FontException";
    };
    maintainers = [ maintainers.fro_ozen ];
    platforms = platforms.unix;
  };
}
