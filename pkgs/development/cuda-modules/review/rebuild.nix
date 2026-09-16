# Full native/cross targets using ordinary production package selection.
{
  source ? ../../../..,
  cross ? true,
  cudaCapabilities ? if cross then [ "12.1a" ] else [ "8.9" ],
}:
let
  fixture = import ./cross-fixture.nix { inherit source cross cudaCapabilities; };
  inherit (fixture) cuda torch;
  lib = import (source + /lib);
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
    ;
  inherit (fixture) mpi nvshmem;
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
    mpi = describe fixture.mpi;
    nvshmem = describe fixture.nvshmem;
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
}
