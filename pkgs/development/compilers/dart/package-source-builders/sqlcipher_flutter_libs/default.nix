{
  stdenv,
  fetchurl,
  lib,
}:

{ version, src, ... }:

let
  artifacts =
    lib.mapAttrs
      (
        version: sha512:
        fetchurl {
          url = "https://storage.googleapis.com/simon-public-euw3/assets/sqlcipher/${version}.c";
          inherit sha512;
        }
      )
      {
        v4_5_7 = "11bb454d761b994f7e44f35dabd3fc8ac3b40499d6fdc29d58a38fb9b4dcdd6eb14ff3978ceb7c6f3bd5eee4a5abeec5f0453b944268f9aaf942b0366df1e73d";
        v4_5_6 = "939ae692239adc0581211a37ed9ffa8b37c8f771c830977ecb06dc6accc4c3db767ce6abeaf91133815e2ae837785affa92f4c95b2e68cb6d563bd761f3e0cb1";
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
      URL="https://storage.googleapis.com/simon-public-euw3/assets/sqlcipher/v$1.c"
      # --replace-fail messes with the file if it fails (is empty afterwards) so we do this instead
      if cat "$out/linux/CMakeLists.txt" | grep "$URL" >/dev/null 2>/dev/null; then
        substituteInPlace "$out/linux/CMakeLists.txt" --replace "$URL" "file://$2"
      else
        return 2
      fi
    }
    _replace "4_5_7" "${artifacts.v4_5_7}" || \
    _replace "4_5_6" "${artifacts.v4_5_6}" || \
    (echo "unknown version of sqlcipher, please add to pkgs/development/compilers/dart/package-source-builders/sqlcipher_flutter_libs" && cat linux/CMakeLists.txt | grep "https://storage.*" -o && exit 2)

    runHook postInstall
  '';

  meta.sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
}
