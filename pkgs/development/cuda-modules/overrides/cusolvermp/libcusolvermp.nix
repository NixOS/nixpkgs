{
  cuda_cudart ? null,
  lib,
  libcal ? null,
  libcublas ? null,
  libcusolver ? null,
  utils,
}:
prevAttrs: {
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions {
      inherit
        cuda_cudart
        libcal
        libcublas
        libcusolver
        ;
    };
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    libcal.lib
    libcublas.lib
    libcusolver.lib
    cuda_cudart.lib
  ];
}
