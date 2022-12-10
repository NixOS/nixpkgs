{ lib
, fetchurl
, symlinkJoin
}:

let
  version = "15.0";

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
      sha256 = "sha256-vRpXHAcdY3arTnFwBH3WUW3DOh8B3L9+sRcecLHZ2lg=";
    };
    emoji-test = fetchData {
      file = "emoji-test.txt";
      sha256 = "sha256-3Rega6+ZJ5jXRhLFL/i/12V5IypEo5FaGG6Wf9Bj0UU=";
    };
    emoji-zwj-sequences = fetchData {
      file = "emoji-zwj-sequences.txt";
      sha256 = "sha256-9AqrpyUCiBcR/fafa4VaH0pT5o1YzEZDVySsX4ja1u8=";
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
