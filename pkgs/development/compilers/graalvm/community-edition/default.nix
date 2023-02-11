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

    Don't change these values! They will be updated by the update script, see ./update.nix.
  */
  graalvm11-ce-release-version = "22.3.0";
  graalvm17-ce-release-version = "22.3.0";

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
