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
    version = "0.36.3";

    src = fetchFromGitHub {
      owner = "tilt-dev";
      repo = "tilt";
      tag = "v${version}";
      hash = "sha256-Rd/39TfKbrW1te//BQYBAZsoxKy9NYKzI8O1s4RXZKA=";
    };
  };

  tilt-assets = callPackage ./assets.nix args;
in
callPackage ./binary.nix (args // { inherit tilt-assets; })
