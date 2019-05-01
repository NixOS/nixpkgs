{ stdenv, fetchzip }:

let
  version = "20141012";
in fetchzip {
  name = "hanazono-${version}";

  url = "mirror://sourceforgejp/hanazono-font/62072/hanazono-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/hanazono $out/share/doc/hanazono
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/hanazono
    unzip -j $downloadedFile \*.txt -d $out/share/doc/hanazono
  '';

  sha256 = "0z0fgrjzp0hqqnhfisivciqpxd2br2w2q9mvxkglj44np2q889w2";

  meta = with stdenv.lib; {
    description = "Free CJK font containing 100K CJK glyphs";
    homepage = http://fonts.jp/hanazono/;
    longDescription = ''CJK font from a Japanese foundry,
    contains CJK Ext-A through EXT-F implemented in full'';
    # Dual-licensed under OFL and the following:
    # This font is a free software.
    # Unlimited permission is granted to use, copy, and distribute it, with
    # or without modification, either commercially and noncommercially.
    # THIS FONT IS PROVIDED "AS IS" WITHOUT WARRANTY.
    license = [ licenses.ofl licenses.free ];
    maintainers = with maintainers; [ mathnerd314 ];
    platforms = platforms.all;
  };
}
