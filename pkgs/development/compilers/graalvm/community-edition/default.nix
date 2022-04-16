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
  graalvm11-ce-dev-version = "22.2.0-dev-20220415_1945";
  graalvm17-ce-dev-version = "22.2.0-dev-20220415_1945";

  products = [
    "graalvm-ce"
    "native-image-installable-svm"
  ];

in
{
  inherit mkGraal;

  graalvm11-ce = mkGraal rec {
    config = {
      x86_64-darwin = {
        inherit products;
        arch = "darwin-amd64";
      };
      x86_64-linux = {
        inherit products;
        arch = "linux-amd64";
      };
      aarch64-darwin = {
        inherit products;
        arch = "darwin-aarch64";
        version = graalvm11-ce-dev-version;
      };
      aarch64-linux = {
        inherit products;
        arch = "linux-aarch64";
      };
    };
    defaultVersion = graalvm11-ce-release-version;
    javaVersion = "11";
  };

  graalvm17-ce = mkGraal rec {
    config = {
      x86_64-darwin = {
        inherit products;
        arch = "darwin-amd64";
      };
      x86_64-linux = {
        inherit products;
        arch = "linux-amd64";
      };
      aarch64-darwin = {
        inherit products;
        arch = "darwin-aarch64";
        version = graalvm17-ce-dev-version;
      };
      aarch64-linux = {
        inherit products;
        arch = "linux-aarch64";
      };
    };
    defaultVersion = graalvm17-ce-release-version;
    javaVersion = "17";
  };
}
