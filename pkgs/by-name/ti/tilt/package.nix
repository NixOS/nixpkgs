{
  fetchFromGitHub,
  substitute,
  callPackage,
  yarn-berry,
}:
let
  args = rec {
    /*
      Do not use "dev" as a version. If you do, Tilt will consider itself
      running in development environment and try to serve assets from the
      source tree, which is not there once build completes.
    */
    version = "0.37.6";

    src = fetchFromGitHub {
      owner = "tilt-dev";
      repo = "tilt";
      tag = "v${version}";
      hash = "sha256-ECECNXxO7fkX3eyNBWMlr9yqgiJKas0XpDA48lQNnr8=";

      # Remove after upstream updates to Yarn 4.15
      # https://github.com/tilt-dev/tilt/blob/master/web/package.json#L98
      postFetch = ''
        cd $out/web
        patch -p1 < ${
          (substitute {
            src = ./yarn-fix.patch;
            substitutions = [
              "--replace-fail"
              "YARN_LOCKFILE_VERSION_PLACEHOLDER"
              yarn-berry.lockfileVersion
            ];
          })
        }
      '';
    };
  };

  tilt-assets = callPackage ./assets.nix (args // { inherit yarn-berry; });
in
callPackage ./binary.nix (args // { inherit tilt-assets; })
