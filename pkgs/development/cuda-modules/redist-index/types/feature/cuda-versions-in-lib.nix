{ lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) const;
  inherit (lib.types) nonEmptyListOf nullOr strMatching;
in
{
  options = mapAttrs (const mkOption) {
    # TODO: We have an additional constraint that we cannot verify from here:
    # 1.  A package with a non-empty `cudaVersionsInLib` feature MUST have a "None" cudaVariant,
    #     because a non-empty `cudaVersionsInLib` indicates that the tarball provides multiple
    #     versions of the library/package for different CUDA versions.
    # 2.  A package with a non-empty `cudaVersionsInLib` feature MUST have a `lib` output.
    cudaVersionsInLib = {
      description = "Subdirectories of the `lib` directory which are named after CUDA versions";
      type = nullOr (nonEmptyListOf (strMatching "^[[:digit:]]+(\.[[:digit:]]+)?$"));
      default = null;
    };
  };
}
