{ stdenv, fetchzip }:

let
  version = "4.002";
in fetchzip {
  name = "kanji-stroke-order-font-${version}";

  url = "https://sites.google.com/site/nihilistorguk/KanjiStrokeOrders_v${version}.zip?attredirects=0";

  postFetch = ''
    mkdir -p $out/share/fonts/kanji-stroke-order $out/share/doc/kanji-stroke-order
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/kanji-stroke-order
    unzip -j $downloadedFile \*.txt -d $out/share/doc/kanji-stroke-order
  '';

  sha256 = "194ylkx5p7r1461wnnd3hisv5dz1xl07fyxmg8gv47zcwvdmwkc0";

  meta = with stdenv.lib; {
    description = "Font containing stroke order diagrams for over 6500 kanji, 180 kana and other characters";
    homepage = "https://sites.google.com/site/nihilistorguk/";

    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ ptrhlm ];
    platforms = platforms.all;
  };
}
