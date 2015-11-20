{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "hanazono-${version}";
  version = "20141012";

  src = fetchurl {
    url = "mirror://sourceforgejp/hanazono-font/62072/hanazono-20141012.zip";
    sha256 = "020jhqnzm9jvkmfvvyk1my26ncwxbnb9yc8v7am252jwrifji9q6";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/hanazono
    cp *.ttf $out/share/fonts/hanazono
    mkdir -p $out/share/doc/hanazono
    cp *.txt $out/share/doc/hanazono
  '';

  meta = with stdenv.lib; {
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
