# Full native/cross targets using ordinary production package selection.
{
  source ? ../../../..,
  cross ? true,
  release ? "13_3",
  enableCudaDriverCompat ? false,
  cudaCapabilities ? if cross then [ "12.1a" ] else [ "8.9" ],
}:
let
  pkgs = import source {
    localSystem = "x86_64-linux";
    crossSystem = if cross then "aarch64-linux" else null;
    config = {
      allowUnfree = true;
      cudaSupport = true;
      inherit cudaCapabilities enableCudaDriverCompat;
      cudaForwardCompat = false;
    };
  };
  lib = import (source + /lib);
  selectRelease =
    release:
    let
      cuda = pkgs."cudaPackages_${release}";
      inherit (cuda.pkgs) mpi;
      nvshmem = cuda.libnvshmem;
      torch = cuda.pkgs.python3Packages.torch;
      magma = lib.findFirst (
        input: lib.getName input == "magma"
      ) (throw "Torch no longer exposes its MAGMA build input") torch.buildInputs;
      runtime = torch.pythonModule.withPackages (ps: [
        torch
        ps.numpy
      ]);
      describe = package: {
        drv = package.drvPath;
        outputs = lib.genAttrs package.outputs (name: package.${name}.outPath);
      };
      runtimeCC = cuda.pkgs.pkgsHostHost.targetPackages.stdenv.cc;
      runtimeTool = package: {
        drv = package.drvPath;
        out = (lib.getBin package).outPath;
      };
    in
    {
      inherit
        torch
        magma
        runtime
        cuda
        mpi
        nvshmem
        ;
      saxpy = cuda.saxpy;
      runtimeTools = {
        torch = describe torch;
        runtime = describe runtime;
        cuda = cuda.cudaMajorMinorVersion;
        capabilities = torch.cudaCapabilities;
        cxx = lib.getExe' runtimeCC "${runtimeCC.targetPrefix}c++";
        tools = lib.mapAttrs (_: runtimeTool) {
          bash = cuda.pkgs.bash;
          ninja = cuda.pkgs.ninja;
          cc = runtimeCC;
          nvcc = cuda.cuda_nvcc;
          cccl = lib.getInclude cuda.cccl;
          cudart = lib.getLib cuda.cuda_cudart;
          cudartInclude = lib.getInclude cuda.cuda_cudart;
        };
      };
      metadata = {
        mpi = describe mpi;
        nvshmem = describe nvshmem;
        torch = describe torch;
        magma = describe magma;
        runtime = describe runtime;
        saxpy = describe cuda.saxpy;
        magmaPkgConfig = describe magma.tests.pkg-config;
        magmaPkgConfigClang = describe magma.tests.pkg-config-clang;
        cuda = torch.cudaPackages.cudaMajorMinorVersion;
        capabilities = torch.cudaCapabilities;
        torchCmakeFlags = torch.cmakeFlags;
        magmaCmakeFlags = magma.cmakeFlags;
        nativeTools = map (input: input.name or (toString input)) torch.nativeBuildInputs;
      };
      interfaces =
        let
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
        // lib.concatMapAttrs (
          name: package:
          lib.optionalAttrs (lib.meta.availableOn pkgs.stdenv.hostPlatform package) (
            lib.mapAttrs' (test: value: lib.nameValuePair "${name}-${test}" value) package.tests
          )
        ) (lib.filterAttrs (name: _: lib.hasPrefix "nvpl_" name) cuda);
      regressions =
        lib.concatMapAttrs
          (
            name: test:
            {
              ${name} = test;
            }
            // lib.mapAttrs' (childName: child: lib.nameValuePair "${name}-${childName}" child) (
              test.tests or { }
            )
          )
          (
            lib.genAttrs [
              "nvcc-discovery"
              "cudart-pkg-config"
              "pkg-config"
              "cudatoolkit"
              "backend-headers"
              "backend-stdenv"
              "scope"
              "nvcc-backend"
              "nvcc-cmake"
              "nvcc-data-outputs"
              "nvcc-fortify"
              "nvcc-hook"
              "nvcc-outputs"
              "nvcc-roles"
              "nvcc-runtime"
              "redist-outputs"
              "redist-variants"
            ] (name: cuda.tests.${name})
          )
        // {
          cudart-no-compiler = cuda.cuda_cudart.tests.no-compiler;
        }
        // lib.optionalAttrs (!cross && release == "12_9") {
          scope-graphs = pkgs.tests.top-level.cudaPackageGraphs;
        };
    };
  releases = lib.genAttrs [ "12_9" "13_3" ] selectRelease;
in
selectRelease release
// {
  matrix = lib.genAttrs [ "interfaces" "regressions" ] (
    group:
    lib.mapAttrs' (
      release: value: lib.nameValuePair "cudaPackages_${release}" (lib.recurseIntoAttrs value.${group})
    ) releases
  );
}
