# NOTE: belongs in cudaLib
# NOTE: cf. tensorrt/releases.nix for a sample input
# NOTE: included in db/default.nix
{
  lib ? import ../../../../lib,
}:

arg:

let
  attrs = if builtins.isPath arg then import arg else arg;
in

assert lib.isAttrs attrs;
assert lib.all (child: child ? releases) (lib.attrValues attrs);

{
  recipes = lib.mapAttrs (name: { releases }: {
    name = lib.mkDefault name;
    platforms = lib.genAttrs (builtins.attrNames releases) (_: "");
  }) attrs;
}
