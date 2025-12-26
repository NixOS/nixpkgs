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
    version = "0.36.0";

    src = fetchFromGitHub {
      owner = "tilt-dev";
      repo = "tilt";
      tag = "v${version}";
      hash = "sha256-M0QZvm+a5sJ6+2xkH3n2yG3SW416VP1fuK6DkFOsQKY=";
    };
  };

  tilt-assets = callPackage ./assets.nix args;
in
callPackage ./binary.nix (args // { inherit tilt-assets; })
