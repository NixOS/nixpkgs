{ stdenv, fetchzip }:

let
  version = "1.010";
in fetchzip {
  name = "inconsolata-${version}";

  url = "http://www.levien.com/type/myfonts/Inconsolata.otf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/opentype/inconsolata.otf";

  sha256 = "1yyf7agabfv0ia57c7in0r33x7c8ay445zf7c3dfc83j6w85g3i7";

  meta = with stdenv.lib; {
    homepage = http://www.levien.com/type/myfonts/inconsolata.html;
    description = "A monospace font for both screen and print";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
