{
  lib,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (types) attrsOf submodule;

  hasValue = name: value: !(value == null || value == { } || value == [ ]);
in
{
  options = {
    archive.sha256 = mkOption {
      # Skips empty `extraConstraints`
      apply = lib.filterAttrs hasValue;
    };
    license.license_path = mkOption {
      apply = lib.filterAttrs hasValue;
    };
    license.distribution_path = mkOption {
      apply = lib.filterAttrs hasValue;
    };
  };
  config = {
    assertions = lib.mkForce [ ];
  };
}
