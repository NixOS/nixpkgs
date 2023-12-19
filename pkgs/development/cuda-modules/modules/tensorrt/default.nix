{ lib, options, ... }:
let
  inherit (lib) types;
  inherit (lib.options) mkOption;
in
{
  options.tensorrt = {
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
  config.tensorrt.releases = builtins.import ./releases.nix;

  # TODO(@connorbaker): Figure out how to add additional options to the
  # to the generic release.
  # {
  #   cudnnVersion = lib.options.mkOption {
  #     description = "The CUDNN version supported";
  #     type = types.nullOr majorMinorVersion;
  #   };
  #   filename = lib.options.mkOption {
  #     description = "The tarball name";
  #     type = types.str;
  #   };
  # }
}
