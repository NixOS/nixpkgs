{ lib
, stdenvNoCC
, fetchurl
, symlinkJoin
}:

let
  version = "15.0";

  fetchData = { suffix, hash }: stdenvNoCC.mkDerivation {
    pname = "unicode-emoji-${suffix}";
    inherit version;

    src = fetchurl {
      url = "https://www.unicode.org/Public/emoji/${version}/emoji-${suffix}.txt";
      inherit hash;
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      installDir="$out/share/unicode/emoji"
      mkdir -p "$installDir"
      cp "$src" "$installDir/emoji-${suffix}.txt"

      runHook postInstall
    '';
  };

  srcs = {
    emoji-sequences = fetchData {
      suffix = "sequences";
      hash = "sha256-XCIi2KQy2JagMaaML1SwT79HsPzi5phT8euKPpRetW0=";
    };
    emoji-test = fetchData {
      suffix = "test";
      hash = "sha256-hEXyOsg4jglr4Z0CYuFPzv+Fb/Ugk/I1bciUhfGoU9s=";
    };
    emoji-zwj-sequences = fetchData {
      suffix = "zwj-sequences";
      hash = "sha256-/jV/kRe3dGZ2Bjdl1YcTft+bJZA6eSvVSTW/CFZ5EYI=";
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
