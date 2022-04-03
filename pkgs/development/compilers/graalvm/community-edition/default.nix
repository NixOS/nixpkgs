{ callPackage, Foundation }:
/*
  Add new graal versions and products here and then see update.nix on how to
  generate the sources.
*/

let
  mkGraal = opts: callPackage (import ./mkGraal.nix opts) {
    inherit Foundation;
  };

  /*
    Looks a bit ugly but makes version update in the update script using sed
    much easier
  */
  graalvm11-ce-release-version = "22.0.0.2";
  graalvm17-ce-release-version = "22.0.0.2";
  graalvm11-ce-dev-version = "22.2.0-dev-20220401_1942";
  graalvm17-ce-dev-version = "22.2.0-dev-20220401_1942";

  commonProducts = [
    "graalvm-ce"
    "native-image-installable-svm"
    "ruby-installable-svm"
    "wasm-installable-svm"
  ];

in
{
  inherit mkGraal;

  graalvm11-ce = mkGraal rec {
    config = {
      x86_64-darwin = {
        arch = "darwin-amd64";
        products = commonProducts ++ [ "python-installable-svm" ];
      };
      x86_64-linux = {
        arch = "linux-amd64";
        products = commonProducts ++ [ "python-installable-svm" ];
      };
      aarch64-darwin = {
        arch = "darwin-aarch64";
        products = [
          "graalvm-ce"
          "native-image-installable-svm"
        ];
        version = graalvm11-ce-dev-version;
      };
      aarch64-linux = {
        arch = "linux-aarch64";
        products = commonProducts;
      };
    };
    defaultVersion = graalvm11-ce-release-version;
    javaVersion = "11";
    platforms = builtins.attrNames config;
  };

  # TODO: fix aarch64-linux, failing during Native Image compilation
  # "Caused by: java.io.IOException: Cannot run program
  # "/nix/store/1q1mif7h3lgxdaxg6j39hli5azikrfla-gcc-wrapper-9.3.0/bin/gcc" (in
  # directory"/tmp/SVM-4194439592488143713"): error=0, Failed to exec spawn
  # helper: pid: 19865, exit value: 1"
  graalvm17-ce = mkGraal rec {
    config = {
      x86_64-darwin = {
        arch = "darwin-amd64";
        products = commonProducts ++ [ "python-installable-svm" ];
      };
      x86_64-linux = {
        arch = "linux-amd64";
        products = commonProducts ++ [ "python-installable-svm" ];
      };
      aarch64-darwin = {
        arch = "darwin-aarch64";
        products = [
          "graalvm-ce"
          "native-image-installable-svm"
        ];
        version = graalvm17-ce-dev-version;
      };
    };
    defaultVersion = graalvm17-ce-release-version;
    javaVersion = "17";
    platforms = builtins.attrNames config;
  };
}
