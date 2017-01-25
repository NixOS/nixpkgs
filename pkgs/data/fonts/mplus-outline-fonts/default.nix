{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mplus-${version}";
  version = "062";

  src = fetchurl {
    url = "mirror://sourceforgejp/mplus-fonts/62344/mplus-TESTFLIGHT-${version}.tar.xz";
    sha256 = "1f44vmnma5njhfiz351gwblxmdh9njv486864zrxqaa1h5pvdhha";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "M+ Outline Fonts";
    homepage = http://mplus-fonts.sourceforge.jp/mplus-outline-fonts/index-en.html;
    license = licenses.mit;
    maintainers = with maintainers; [ henrytill ];
    platforms = platforms.all;
  };
}
