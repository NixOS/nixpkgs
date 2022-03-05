{ lib, fetchgit, fetchFromGitHub }:

let
  version = "5.15.3";
  overrides = {
    qtscript.version = "5.15.4";
  };

  mk = name: args:
    let
      override = overrides.${name} or {};
    in
    {
      version = override.version or version;
      src = override.src or
        fetchgit {
          inherit (args) url rev sha256;
          fetchLFS = false;
          fetchSubmodules = false;
          deepClone = false;
          leaveDotGit = false;
        };
    };
in
lib.mapAttrs mk (lib.importJSON ./srcs-generated.json)
// {
  # qtwebkit does not have an official release tarball on the qt mirror and is
  # mostly maintained by the community.
  qtwebkit = rec {
    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtwebkit";
      rev = "v${version}";
      sha256 = "0x8rng96h19xirn7qkz3lydal6v4vn00bcl0s3brz36dfs0z8wpg";
    };
    version = "5.212.0-alpha4";
  };

  qtwebengine =
    let
      branchName = "5.15.8";
      rev = "v${branchName}-lts";
    in
    {
      version = branchName;

      src = fetchgit {
        url = "https://github.com/qt/qtwebengine.git";
        sha256 = "04xhg5qpnxm8hzgkanml45za64c9i5pbxhki2l2wcq4b4y7f3hyr";
        inherit rev branchName;
        fetchSubmodules = true;
        leaveDotGit = true;
        name = "qtwebengine-${lib.substring 0 7 rev}.tar.gz";
        postFetch = ''
          # remove submodule .git directory
          rm -rf "$out/src/3rdparty/.git"

          # compress to not exceed the 2GB output limit
          # try to make a deterministic tarball
          tar -I 'gzip -n' \
            --sort=name \
            --mtime=1970-01-01 \
            --owner=root --group=root \
            --numeric-owner --mode=go=rX,u+rw,a-s \
            --transform='s@^@source/@' \
            -cf temp  -C "$out" .
          rm -r "$out"
          mv temp "$out"
        '';
      };
    };
}
