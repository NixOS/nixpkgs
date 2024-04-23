{ config, lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) const;
  inherit (lib.types) nonEmptyStr nullOr submodule;
in
{
  options.data.indices = mapAttrs (const mkOption) {
    sha256AndRelativePath = {
      description = ''
        Index of NVIDIA's sha256 hashes of their tarballs and relative paths when unable to be derived from context.
      '';
      type = config.types.indexOf (submodule {
        options = mapAttrs (const mkOption) {
          relativePath = {
            type = nullOr nonEmptyStr;
            default = null;
          };
          sha256.type = config.types.sha256;
        };
      });
      default = { };
      # Given them empty defaults to avoid breaking evaluation when the index has not been generated.
      # A true default value would require impure derivations to run and access the internet.
    };
  };
}
