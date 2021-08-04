{ callPackage, Foundation }:

let
  mkGraal = opts: callPackage (import ./repository.nix opts) {
    inherit Foundation;
  };
in {
  inherit mkGraal;

  graalvm8-ce = mkGraal rec {
    version = "21.2.0";
    javaVersion = "8";
    platforms = ["x86_64-linux"];
  };

  graalvm11-ce = mkGraal rec {
    version = "21.2.0";
    javaVersion = "11";
    platforms = ["x86_64-linux" "x86_64-darwin"];
  };
}
