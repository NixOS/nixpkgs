# NOTE: belongs in cudaLib
# NOTE: cf. tensorrt/releases.nix for a sample input
# NOTE: included in db/default.nix
let
  inherit (import ./nixpkgs_paths.nix) libPath;
in
{
  lib ? import libPath,
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
  release.product = lib.mapAttrs (pname: _: 1) attrs;
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
          package.version.${pname}.${p.version}.${p.hash} = 1;
          archive.sha256.${p.hash} = {
            inherit systemNv;
            url = "${
              lib.replaceStrings
                [ "{version}" "{versionTriple}" ]
                [ p.version (lib.concatStringsSep "." (lib.take 3 (lib.splitVersion p.version))) ]
                config.trt_base_url
            }${p.filename}";
            extraConstraints =
              let
                nextVersion =
                  version:
                  let
                    ints = map lib.toInt (lib.splitVersion version);
                    intsNext = lib.take (lib.length ints - 1) ints ++ [ (lib.last ints + 1) ];
                  in
                  lib.concatMapStringsSep "." toString intsNext;
              in
              {
                "cuda" =
                  lib.optionalAttrs (p.maxCudaVersion or null != null) {
                    "<" = nextVersion p.maxCudaVersion;
                  }
                  // lib.optionalAttrs (p.minCudaVersion or null != null) {
                    ">=" = p.minCudaVersion;
                  };
              }
              // lib.optionalAttrs (p.cudnnVersion or null != null) {
                "cudnn"."<" = nextVersion p.cudnnVersion;
                "cudnn".">=" = p.cudnnVersion;
              };
          };
        }) packages
      ) (lib.attrsToList releases)

    ) attrs

  );
}
