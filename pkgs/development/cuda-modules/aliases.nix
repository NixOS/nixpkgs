# Packages which have been deprecated or removed from cudaPackages
final:
let
  inherit (builtins) mapAttrs;
  inherit (final.lib.trivial) warn;

  mkRenamed =
    oldName:
    { path, package }:
    warn "cudaPackages.${oldName} is deprecated, use ${path} instead" package;
in
mapAttrs mkRenamed {
  # A comment to prevent empty { } from collapsing into a single line
}
