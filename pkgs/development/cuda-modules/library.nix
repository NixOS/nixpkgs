{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
  lib,
  ...
}:
# These runtime libraries publish CUDART types through their pkg-config modules.
lib.extendMkDerivation {
  constructDrv = buildRedist;
  extendDrvArgs =
    finalAttrs:
    {
      redistName ? "cuda",
      outputs ? [
        "out"
        "dev"
        "include"
        "lib"
        "static"
        "stubs"
      ],
      propagatedBuildInputs ? [ cuda_cudart ],
      postPatch ? "",
      ...
    }:
    {
      inherit redistName;
      inherit outputs propagatedBuildInputs;
      postPatch = postPatch + ''
        substituteInPlace share/pkgconfig/*-${cudaMajorMinorVersion}.pc \
          --replace-fail 'Cflags:' $'Requires: cudart-${cudaMajorMinorVersion}\nCflags:'
      '';
    };
}
