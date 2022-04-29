{ lib
, fetchurl
, symlinkJoin
}:

let
  version = "14.0";

  fetchData = { file, sha256 }: fetchurl {
    url = "https://www.unicode.org/Public/emoji/${version}/${file}";
    inherit sha256;
    downloadToTemp = true;
    recursiveHash = true;
    postFetch = ''
      installDir="$out/share/unicode/emoji"
      mkdir -p "$installDir"
      mv "$downloadedFile" "$installDir/${file}"
    '';
  };

  srcs = {
    emoji-sequences = fetchData {
      file = "emoji-sequences.txt";
      sha256 = "sha256-4helD/0oe+UmNIuVxPx/P0R9V10EY/RccewdeemeGxE=";
    };
    emoji-test = fetchData {
      file = "emoji-test.txt";
      sha256 = "sha256-DDOVhnFzfvowINzBZ7dGYMZnL4khyRWVzrLL95djsUg=";
    };
    emoji-zwj-sequences = fetchData {
      file = "emoji-zwj-sequences.txt";
      sha256 = "sha256-owlGLICFkyEsIHz/DUZucxjBmgVO40A69BCJPbIYDA0=";
    };
  };
in

symlinkJoin rec {
  name = "unicode-emoji-${version}";

  paths = lib.attrValues srcs;

  passthru = srcs;

  meta = with lib; {
    description = "Unicode Emoji Data Files";
    homepage = "https://home.unicode.org/emoji/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
