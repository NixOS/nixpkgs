{ lib, config, ... }:
{
  options.generic.manifests = {
    feature = import ./feature/manifest.nix { inherit lib config; };
    redistrib = import ./redistrib/manifest.nix { inherit lib; };
  };
}
