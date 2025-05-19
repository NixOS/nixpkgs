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

rec {
  packages = {
    pnames = lib.mapAttrs (pname: _: 1) attrs;
    name = lib.mapAttrs (pname: _: pname) attrs;
    systemsNv = lib.mapAttrs (pname: { releases }: lib.mapAttrs (_: _: 1) releases) attrs;
  };
  systems = {
    nvidia = lib.concatMapAttrs (_: lib.id) packages.systemsNv;
  };
  _file = if builtins.isPath arg then arg else ./release_file.nix;
}
