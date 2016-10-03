{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mplus-${version}";
  version = "061";

  src = fetchurl {
    url = "mirror://sourceforgejp/mplus-fonts/62344/mplus-TESTFLIGHT-${version}.tar.xz";
    sha256 = "1yrv65l2y8f9jmpalqb5iiay7z1x3754mnqpgp2bax72g8k8728g";
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
