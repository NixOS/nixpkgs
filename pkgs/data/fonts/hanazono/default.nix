{ lib, fetchzip }:

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

  meta = with lib; {
    description = "Free kanji font containing 96,327 characters";
    homepage = http://fonts.jp/hanazono/;

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
