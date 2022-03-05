{ lib, callPackage, Foundation }:

let
  mkGraal = opts: callPackage (import ./mkGraal.nix opts) {
    inherit Foundation;
  };
in
{
  inherit mkGraal;

  graalvm11-ce = mkGraal rec {
    version = "22.0.0.2";
    javaVersion = "11";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };

  # TODO: fix aarch64-linux, failing during Native Image compilation
  # "Caused by: java.io.IOException: Cannot run program
  # "/nix/store/1q1mif7h3lgxdaxg6j39hli5azikrfla-gcc-wrapper-9.3.0/bin/gcc" (in
  # directory"/tmp/SVM-4194439592488143713"): error=0, Failed to exec spawn
  # helper: pid: 19865, exit value: 1"
  graalvm17-ce = mkGraal rec {
    version = "22.0.0.2";
    javaVersion = "17";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
