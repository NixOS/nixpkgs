{
  lib,
  stdenvNoCC,
  fetchurl,
  symlinkJoin,
}:

let
  version = "17.0";

  fetchData =
    { suffix, hash }:
    stdenvNoCC.mkDerivation {
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
      hash = "sha256-M1txywy3BISmMxoXYzGmg+LOafAdZOtAPu5mnE1XA5g=";
    };
    emoji-test = fetchData {
      suffix = "test";
      hash = "sha256-EYHEVX845REBhFBFD51CV02qiA0TQ9WsYfE0h34+veU=";
    };
    emoji-zwj-sequences = fetchData {
      suffix = "zwj-sequences";
      hash = "sha256-WyVEHa7SMisGjF5wzaUilGpPAnTfhkRFoZZakuX8XK0=";
    };
  };
in

symlinkJoin {
  name = "unicode-emoji-${version}";

  paths = lib.attrValues srcs;

  passthru = srcs;

  meta = {
    description = "Unicode Emoji Data Files";
    homepage = "https://home.unicode.org/emoji/";
    license = lib.licenses.unicode-dfs-2016;
    platforms = lib.platforms.all;
  };
}
