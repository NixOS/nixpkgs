{ stdenv
, fetchurl
, symlinkJoin
, lib
}:

let
  version = "12.1";

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
    emoji-data = fetchData {
      file = "emoji-data.txt";
      sha256 = "17gfm5a28lsymx36prbjy2g0b27gf3rcgggy0yxdshbxwf6zpf9k";
    };
    emoji-sequences = fetchData {
      file = "emoji-sequences.txt";
      sha256 = "1fckw5hfyvz5jfp2jczzx8qcs79vf0zyq0z2942230j99arq70vc";
    };
    emoji-test = fetchData {
      file = "emoji-test.txt";
      sha256 = "0w29lva7gp9g9lf7bz1i24qdalvf440bcq8npsbwr3cpp7na95kh";
    };
    emoji-variation-sequences = fetchData {
      file = "emoji-variation-sequences.txt";
      sha256 = "0akpib3cinr8xcs045hda5wnpfj6qfdjlkzmq5vgdc50gyhrd2z3";
    };
    emoji-zwj-sequences = fetchData {
      file = "emoji-zwj-sequences.txt";
      sha256 = "0s2mvy1nr2v1x0rr1fxlsv8ly1vyf9978rb4hwry5vnr678ls522";
    };
  };
in

symlinkJoin rec {
  name = "unicode-emoji-${version}";

  paths = lib.attrValues srcs;

  passthru = srcs;

  meta = with stdenv.lib; {
    description = "Unicode Emoji Data Files";
    homepage = "https://home.unicode.org/emoji/";
    license = licenses.free; # https://www.unicode.org/license.html
    platforms = platforms.all;
  };
}
