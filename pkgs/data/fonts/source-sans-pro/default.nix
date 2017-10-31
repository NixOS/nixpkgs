{ stdenv, fetchzip }:

fetchzip {
  name = "source-sans-pro-2.010";

  url = "https://github.com/adobe-fonts/source-sans-pro/archive/2.010R-ro/1.065R-it.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "17rgkh54arybmcdg750ynw32x2sps7p9vrvq9kpih8vdghwrh9k2";

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/adobe/sourcesans;
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
