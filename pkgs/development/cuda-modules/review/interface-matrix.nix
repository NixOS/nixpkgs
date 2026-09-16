# Installed public interfaces, with only one GPU architecture per build role.
{
  source ? ../../../..,
  releases ? [
    "12_9"
    "13_3"
  ],
}:
let
  lib = import (source + /lib);
  role =
    cross:
    let
      pkgs = import source {
        localSystem = "x86_64-linux";
        crossSystem = if cross then "aarch64-linux" else null;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = if cross then [ "12.1a" ] else [ "8.9" ];
          cudaForwardCompat = false;
        };
      };
    in
    lib.genAttrs releases (
      release:
      let
        cuda = pkgs."cudaPackages_${release}";
        frontend =
          withJson:
          (cuda.cudnn-frontend.override {
            withSamples = false;
            withTests = false;
            inherit withJson;
          }).tests.cmake;
      in
      lib.genAttrs [
        "cuda_cupti"
        "cudnn"
        "libcublasmp"
        "libcusolvermp"
        "libcusparse_lt"
        "libcutensor"
        "cuquantum"
      ] (name: cuda.${name}.tests.headers)
      // {
        cutlass = cuda.cutlass.tests.cmake;
        cudnn-frontend = frontend true;
        cudnn-frontend-without-json = frontend false;
        nvshmem = cuda.libnvshmem.tests.cmake;
      }
      // lib.optionalAttrs (lib.meta.availableOn pkgs.stdenv.hostPlatform cuda.libcudss) {
        cudss = cuda.libcudss.tests.cmake;
      }
    );
in
{
  native = role false;
  cross = role true;
}
