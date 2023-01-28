{ lib, fetchgit, fetchFromGitHub }:

let
  version = "5.15.8";
  overrides = {};

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
  qt3d = {
    inherit version;
    src = fetchgit {
      url = "https://invent.kde.org/qt/qt/qt3d.git";
      rev = "c3c7e6ebc29cce466d954f72f340a257d76b5ec2";
      sha256 = "sha256-KMWZ4N2OO7TBVpcgvQf/gweZRT62i9XABOnq0x94PY4=";
      fetchLFS = false;
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
    };
  };

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

  catapult = fetchgit {
    url = "https://chromium.googlesource.com/catapult";
    rev = "5eedfe23148a234211ba477f76fc2ea2e8529189";
    hash = "sha256-LPfBCEB5tJOljXpptsNk0sHGtJf/wIRL7fccN79Nh6o=";
  };

  qtwebengine =
    let
      branchName = "5.15.11";
      rev = "v${branchName}-lts";
    in
    {
      version = branchName;

      src = fetchgit {
        url = "https://github.com/qt/qtwebengine.git";
        sha256 = "sha256-yrKPof18G10VjrwCn/4E/ywlpATJQZjvmVeM+9hLY0U=";
        inherit rev branchName;
        fetchSubmodules = true;
        leaveDotGit = true;
        name = "qtwebengine-${lib.substring 0 8 rev}.tar.gz";
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
