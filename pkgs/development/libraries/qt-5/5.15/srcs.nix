{ lib, fetchgit }:

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
