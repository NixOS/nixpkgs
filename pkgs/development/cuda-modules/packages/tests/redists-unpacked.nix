{
  cudaNamePrefix,
  cudaPackages,
  lib,
  linkFarm,
}:
linkFarm "${cudaNamePrefix}-redists-unpacked" (
  lib.concatMapAttrs (
    name: attr:
    lib.optionalAttrs (attr ? passthru.redistName && attr.src or null != null) {
      ${name} = attr.src;
    }
  ) cudaPackages
)
