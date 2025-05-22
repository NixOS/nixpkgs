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

{ config, ... }:

rec {
  package = {
    pname = lib.mapAttrs (pname: _: 1) attrs;
    name = lib.mapAttrs (pname: _: pname) attrs;
    systemsNv = lib.mapAttrs (pname: { releases }: lib.mapAttrs (_: _: 1) releases) attrs;
  };
  product = lib.mapAttrs (pname: _: 1) attrs;
  system = {
    nvidia = lib.concatMapAttrs (_: lib.id) package.systemsNv;
  };
  _file = if builtins.isPath arg then arg else ./release_file.nix;
  imports = lib.flatten (
    lib.mapAttrsToList (
      pname:
      { releases }:
      lib.concatMap (
        nameValue:
        let
          systemNv = nameValue.name;
          packages = nameValue.value;
        in
        builtins.map (p: {
          archive.bucket.${pname}.${p.version}.${p.hash} = 1;
          archive.sha256.${p.hash} = {
            inherit systemNv;
            url = "${lib.replaceStrings [ "{version}" ] [ p.version ] config.trt_base_url}${p.filename}";
          };
        }) packages
      ) (lib.attrsToList releases)

    ) attrs

  );
}
