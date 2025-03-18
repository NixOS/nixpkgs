# Packages which have been deprecated or removed from cudaPackages
final: prev:
let
  inherit (prev.lib) warn;
  inherit (builtins) mapAttrs;

  mkRenamed =
    oldName:
    { path, package }:
    warn "cudaPackages.${oldName} is deprecated, use ${path} instead" package;
in
mapAttrs mkRenamed {
  # A comment to prevent empty { } from collapsing into a single line
}
