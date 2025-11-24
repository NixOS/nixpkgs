{
  stdenv,
  fetchurl,
  lib,
}:

{ version, src, ... }:

let
  artifacts =
    lib.mapAttrs
      (version: hash: rec {
        file = fetchurl {
          inherit url hash;
        };
        url =
          if lib.versionOlder version "v4_6_1" then
            "https://storage.googleapis.com/simon-public-euw3/assets/sqlcipher/${version}.c"
          else
            "https://fsn1.your-objectstorage.com/simon-public/assets/sqlcipher/${version}.c";
      })
      {
        v4_10_0 = "sha256-3njvCHy8Juj+WE3gXxeQ8+NIl9uHMegVTcZ00/LfKMs=";
        v4_9_0 = "sha256-uqvW5BgMjCS0GzeEDeGskb4It0NkWjNUpyXpGlBSIlc=";
        v4_8_0 = "sha256-nfYmi9PJlMbLqiFRksOIUXYHgD8LL2AVey9GCUc03Jw=";
        v4_6_1 = "sha256-8kBJiy8g1odpBQQUF5A7f9g3+WStbJTARyfvAi84YVE=";
        v4_5_7 = "sha256-lDgSEVGZcoruF7nAp0C2kr6TN7XllpMzMVi/R1XfGP4=";
        v4_5_6 = "sha256-evZl3JUeyAfW0fGJ0EfFQs64Z/yRCZGeOeDGgXrFHFU=";
      };
in
stdenv.mkDerivation rec {
  pname = "sqlcipher_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  installPhase = ''
    runHook preInstall

    cp -r "$src" "$out"
    _replace() {
      # --replace-fail messes with the file if it fails (is empty afterwards) so we do this instead
      if cat "$out/linux/CMakeLists.txt" | grep "$1" >/dev/null 2>/dev/null; then
        substituteInPlace "$out/linux/CMakeLists.txt" --replace "$1" "file://$2"
      else
        return 2
      fi
    }

    ${lib.concatMapAttrsStringSep " || " (_: v: ''_replace "${v.url}" "${v.file}"'') artifacts} || \
    (echo "unknown version of sqlcipher, please add to pkgs/development/compilers/dart/package-source-builders/sqlcipher_flutter_libs" && cat linux/CMakeLists.txt | grep "https://storage.*" -o && exit 2)

    runHook postInstall
  '';

  meta.sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
}
