{ config, lib, options, ... }:
let
  inherit (lib) filesystem modules;
  opt = options.generic.manifests;
  cfg = config.generic.manifests;
in
{
  options.cuda = opt.options;
  config.cuda = {
    manifestPaths = modules.mkDefault (filesystem.listFilesRecursive ./manifests);
    manifestMetas = modules.mkDefault (
      builtins.map cfg.utils.manifestPathToManifestMeta config.cuda.manifestPaths
    );
    manifests = modules.mkDefault (cfg.utils.manifestMetasToManifests config.cuda.manifestMetas);
    generalFixupFn = modules.mkDefault ./fixup.nix;
    indexedFixupFn = modules.mkDefault ./fixups.nix;
  };
}
