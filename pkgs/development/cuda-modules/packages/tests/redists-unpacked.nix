{
  cudaNamePrefix,
  cudaPackages,
  lib,
  linkFarm,
}:
# NOTE: Because Nixpkgs, by default, allows aliases, this derivation may contain multiple entries for a single redistributable.
let
  redistsForPlatform = lib.filterAttrs (
    _: value: value ? passthru.redistName && value.src or null != null
  ) cudaPackages;

  linkedWithoutLicenses = linkFarm "${cudaNamePrefix}-redists-unpacked" (
    lib.mapAttrs (_: drv: drv.src) redistsForPlatform
  );
in
linkedWithoutLicenses.overrideAttrs (prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    inherit redistsForPlatform;
  };

  meta = prevAttrs.meta or { } // {
    license = lib.unique (
      lib.concatMap (drv: lib.toList (drv.meta.license or [ ])) (lib.attrValues redistsForPlatform)
    );
  };
})
