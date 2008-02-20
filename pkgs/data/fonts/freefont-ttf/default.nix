{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "freefont-ttf-20060126";
  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/freefont/freefont-ttf-20060126.tar.gz;
    md5 = "822aba4e2ed065d9d3ded6e26e495854";
  };
  installPhase = ''
    ensureDir $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
}
