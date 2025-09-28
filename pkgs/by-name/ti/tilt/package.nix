{
  fetchFromGitHub,
  callPackage,
}:
let
  args = rec {
    /*
      Do not use "dev" as a version. If you do, Tilt will consider itself
      running in development environment and try to serve assets from the
      source tree, which is not there once build completes.
    */
    version = "0.35.1";

    src = fetchFromGitHub {
      owner = "tilt-dev";
      repo = "tilt";
      tag = "v${version}";
      hash = "sha256-rM5INMOECbnuWd4ealBcIuMwZij7MthrXfohOBavl8Y=";
    };
  };

  tilt-assets = callPackage ./assets.nix args;
in
callPackage ./binary.nix (args // { inherit tilt-assets; })
