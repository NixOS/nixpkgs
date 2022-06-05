{ lib, stdenv, fetchurl }:

let
  version = "4.003";
  debianVersion = "dfsg-1";
in stdenv.mkDerivation {
  name = "kanji-stroke-order-font-${version}";

  src = fetchurl {
    url = "https://salsa.debian.org/fonts-team/fonts-kanjistrokeorders/-/archive/debian/${version}_${debianVersion}/fonts-kanjistrokeorders-debian-${version}_${debianVersion}.tar.bz2";
    sha256 = "1a8hxzkrfjz0h5gl9h0panzzsn7cldlklxryyzmpam23g32q6bg1";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/kanji-stroke-order $out/share/doc/kanji-stroke-order
    cp *.ttf $out/share/fonts/kanji-stroke-order
    cp *.txt $out/share/doc/kanji-stroke-order
  '';

  meta = with lib; {
    description = "Font containing stroke order diagrams for over 6500 kanji, 180 kana and other characters";
    homepage = "https://sites.google.com/site/nihilistorguk/";

    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ ptrhlm ];
    platforms = platforms.all;
  };
}
