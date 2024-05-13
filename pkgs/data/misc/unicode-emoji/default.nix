{ lib
, stdenvNoCC
, fetchurl
, symlinkJoin
}:

let
  version = "15.1";

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
      hash = "sha256-63LJEV41BPu+HIYhthn4eUcaRszFbi9EVBe3wcrQUNE=";
    };
    emoji-test = fetchData {
      suffix = "test";
      hash = "sha256-2HbuJJqijqp2z6bfqnAoR6jROwYqpIjUZdA5XugTftk=";
    };
    emoji-zwj-sequences = fetchData {
      suffix = "zwj-sequences";
      hash = "sha256-mnagPcrPzY+b/gjEnI2QtVGCuXfLzIemlOioGT77Dlc=";
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
