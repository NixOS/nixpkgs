{ lib, callPackage, Foundation }:

let
  mkGraal = opts: callPackage (import ./mkGraal.nix opts) {
    inherit Foundation;
  };
in
{
  inherit mkGraal;

  graalvm11-ce = mkGraal rec {
    version = lib.fileContents ./version;
    javaVersion = "11";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };

  # TODO: added graalvm17-ce
}
