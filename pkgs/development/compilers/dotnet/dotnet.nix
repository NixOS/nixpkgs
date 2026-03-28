{
  config,
  callPackage,
  lib,
  dir ? null,
  releasesFile ? dir + "/releases.nix",
  buildDotnetSdk,
  withVMR ? true,
  ...
}@attrs:

let
  binary = buildDotnetSdk releasesFile;

  sourcePackages = lib.optionalAttrs withVMR (callPackage ./source (attrs // { inherit binary; }));

  pkgs =
    lib.optionalAttrs config.allowAliases binary
    // lib.mapAttrs' (k: v: lib.nameValuePair "${k}-bin" v) binary
    // sourcePackages;
in
pkgs
