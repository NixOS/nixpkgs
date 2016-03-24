{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mplus-${version}";
  version = "059";

  src = fetchurl {
    url = "mirror://sourceforgejp/mplus-fonts/62344/mplus-TESTFLIGHT-059.tar.xz";
    sha256 = "09dzdgqqflpijd3c30m38cyidshawfp4nz162xhn91j9w09y2qkq";
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
