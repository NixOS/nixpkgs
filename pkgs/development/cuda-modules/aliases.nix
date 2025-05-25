# Packages which have been deprecated or removed from cudaPackages
final: _:
let
  mkRenamed =
    oldName:
    { path, package }:
    final.lib.warn "cudaPackages.${oldName} is deprecated, use ${path} instead" package;
in
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
}
