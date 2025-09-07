{
  cudaNamePrefix,
  cudaPackages,
  lib,
  linkFarm,
}:
linkFarm "${cudaNamePrefix}-redists-installed" (
  lib.concatMapAttrs (
    name: attr:
    lib.optionalAttrs (attr ? passthru.redistName && attr.meta.available or false) (
      lib.genAttrs' attr.outputs (output: {
        name = "${name}-${output}";
        value = attr.${output};
      })
    )
  ) cudaPackages
)
