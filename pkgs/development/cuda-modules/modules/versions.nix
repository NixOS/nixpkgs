{config, lib, ...}:
let
  inherit (lib) options types;
in
{
  options.versions = options.mkOption {
    description = "A list of CUDA versions to create package sets for";
    type = types.listOf (config.generic.types.majorMinorVersion);
    default = [
      # CUDA 10
      "10.0"
      "10.1"
      "10.2"
      # CUDA 11
      "11.0"
      "11.1"
      "11.2"
      "11.3"
      "11.4"
      "11.5"
      "11.6"
      "11.7"
      "11.8"
      # CUDA 12
      "12.0"
      "12.1"
      "12.2"
      "12.3"
    ];
  };
}