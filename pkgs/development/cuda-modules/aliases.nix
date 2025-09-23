# Packages which have been deprecated or removed from cudaPackages
{ lib }:
let
  mkRenamed =
    oldName:
    { path, package }:
    lib.warn "cudaPackages.${oldName} is deprecated, use ${path} instead" package;
in
final: _:
builtins.mapAttrs mkRenamed {
  # A comment to prevent empty { } from collapsing into a single line

  cudaFlags = {
    path = "cudaPackages.flags";
    package = final.flags;
  };

  cudaVersion = {
    path = "cudaPackages.cudaMajorMinorVersion";
    package = final.cudaMajorMinorVersion;
  };

  cudatoolkit-legacy-runfile = {
    path = "cudaPackages.cudatoolkit";
    package = final.cudatoolkit;
  };

  cusparselt = {
    path = "cudaPackages.libcusparse_lt";
    package = final.libcusparse_lt;
  };
}
