{
  lib,
  stdenvNoCC,
  fetchurl,
  symlinkJoin,
}:

let
  version = "16.0";

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
      hash = "sha256-P+PHfnLo8m3zAtx9mbEGxdCP2Ajvckb7XUUC1ln+ZZw=";
    };
    emoji-test = fetchData {
      suffix = "test";
      hash = "sha256-JPDFNOhs8ULiSWlT6PDkaj5wI5KRHt3NKcbM7YUTlpc=";
    };
    emoji-zwj-sequences = fetchData {
      suffix = "zwj-sequences";
      hash = "sha256-lCPsI1R0NW+XCmllBnN+LV1lRTpn9F32a4u+kgw/q4M=";
    };
  };
in

symlinkJoin {
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
