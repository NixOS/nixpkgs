{ stdenv, lib, fetchzip }:

{ version, src, ... }:

let
  sqlite = lib.mapAttrs (version: hash:
    rec {
      url = "https://sqlite.org/2024/sqlite-autoconf-${import ./archive-version.nix lib version}.tar.gz";
      src = fetchzip {
        inherit url hash;
      };
    }) {
      "3.45.1" = "sha256-BkcEqyVyV0XmPHjgI1N9JXQeQ4wWfkC8uZrONU6kZ0w=";
      "3.46.0" = "sha256-3qIBBPHFw2ZNxQG3vU7RTr3FXb8hu+1LnD/vC9GoKpY=";
    };
in stdenv.mkDerivation rec {
  pname = "sqlite3_flutter_libs";
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
    _replace "${sqlite."3.45.1".url}" "${sqlite."3.45.1".src}" || \
    _replace "${sqlite."3.46.0".url}" "${sqlite."3.46.0".src}" || \
    (echo "unknown version of sqlite3, please add to pkgs/development/compilers/dart/package-source-builders/sqlite3_flutter_libs" && cat linux/CMakeLists.txt | grep "https://sqlite.org.*" -o | uniq && exit 2)

    runHook postInstall
  '';

  meta.sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
}
