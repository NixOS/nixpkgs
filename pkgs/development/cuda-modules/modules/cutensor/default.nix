{ config, lib, options, ... }:
let
  inherit (lib) filesystem modules;
  opt = options.generic.manifests;
  cfg = config.generic.manifests;
in
{
  options.cutensor = opt.options;
  config.cutensor = {
    manifestPaths = modules.mkDefault (filesystem.listFilesRecursive ./manifests);
    manifestMetas = modules.mkDefault (
      builtins.map cfg.utils.manifestPathToManifestMeta config.cutensor.manifestPaths
    );
    manifests = modules.mkDefault (cfg.utils.manifestMetasToManifests config.cutensor.manifestMetas);
    generalFixupFn = modules.mkDefault ./fixup.nix;
  };
}
