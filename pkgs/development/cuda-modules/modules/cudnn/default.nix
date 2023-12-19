{lib, options, ...}:
let
  inherit (lib) types;
  inherit (lib.options) mkOption;
in 
{
  options.cudnn = {
    inherit (options.generic) releases;
    shimsFnPath = mkOption {
      description = "The path to a function to transform releases into manifest files";
      default = ./shims.nix;
      type = types.path;
    };
    fixupFnPath = mkOption {
      description = "The path to a function to transform releases into manifest files";
      default = ./fixup.nix;
      type = types.path;
    };
  };
  config.cudnn.releases = builtins.import ./releases.nix;

  # TODO(@connorbaker): Figure out how to add additional options to the
  # to the generic release.
  # {
  #   url = options.mkOption {
  #     description = "The URL to download the tarball from";
  #     type = types.str;
  #   };
  # }
}
