{
  lib,
  lndir,
  symlinkJoin,
  backendCC,
  cudaMajorMinorVersion,
  cccl ? null,
  cuda_crt ? null,
  cuda_cudart ? null,
  cuda_cuobjdump ? null,
  cuda_cupti ? null,
  cuda_cuxxfilt ? null,
  cuda_gdb ? null,
  cuda_nvcc ? null,
  cuda_nvdisasm ? null,
  cuda_nvml_dev ? null,
  cuda_nvprune ? null,
  cuda_nvrtc ? null,
  cuda_nvtx ? null,
  cuda_profiler_api ? null,
  cuda_sanitizer_api ? null,
  libcublas ? null,
  libcufft ? null,
  libcurand ? null,
  libcusolver ? null,
  libcusparse ? null,
  libnpp ? null,
  libnvptxcompiler ? null,
}:

let
  # Retrieve all the outputs of a package except for the "static" output.
  getAllOutputs =
    p:
    lib.optionals (p != null) (
      lib.concatMap (output: lib.optionals (output != "static") [ p.${output} ]) p.outputs
    );

  hostPackages = [
    cuda_cuobjdump
    cuda_cuxxfilt
    cuda_gdb
    cuda_nvcc
    cuda_nvdisasm
    cuda_nvprune
  ];
  targetPackages = [
    cccl
    cuda_crt
    cuda_cudart
    cuda_cupti
    cuda_nvml_dev
    cuda_nvrtc
    cuda_nvtx
    cuda_profiler_api
    cuda_sanitizer_api
    libcublas
    libcufft
    libcurand
    libcusolver
    libcusparse
    libnpp
    libnvptxcompiler
  ];

  # Like NVCC, this package runs on HOST and compiles for TARGET. Consumers
  # select its BUILD -> HOST instance with nativeBuildInputs, or HOST -> HOST
  # for runtime compilation. Never bake BUILD executables into a HOST package.
  targetPackagesForTarget = map (p: p.__spliced.targetTarget or p) targetPackages;
  hostComponents = builtins.concatMap getAllOutputs hostPackages;
  targetComponents = builtins.concatMap getAllOutputs targetPackagesForTarget;
  libraryComponents = map lib.getLib (lib.filter (p: p != null) targetPackagesForTarget);
in
symlinkJoin {
  pname = "cuda-merged";
  version = cudaMajorMinorVersion;
  # Keep the legacy .lib access as a real output, so ordinary output splicing
  # applies. Both outputs use the same TARGET component selection, while
  # library consumers need not retain HOST executables in their closure.
  outputs = [
    "out"
    "lib"
  ];

  paths = hostComponents ++ targetComponents;
  nativeBuildInputs = [ lndir ];
  # A symlinkJoin cannot merge the per-output nix-support files: each path has
  # the same file names, so lndir keeps whichever one it sees first. Replace
  # those collisions with propagation of the actual component outputs.
  postBuild = ''
    mkdir -p "$lib"
    for component in ${lib.escapeShellArgs libraryComponents}; do
      lndir -silent "$component" "$lib"
    done
    for output in "$out" "$lib"; do
      rm -rf "$output/nix-support"
      mkdir -p "$output/nix-support"
    done
    printWords ${lib.escapeShellArgs hostComponents} \
      >"$out/nix-support/propagated-build-inputs"
    printWords ${lib.escapeShellArgs targetComponents} \
      >"$out/nix-support/propagated-target-target-deps"
    printWords ${lib.escapeShellArgs libraryComponents} \
      >"$lib/nix-support/propagated-target-target-deps"
  '';

  passthru = {
    cc = lib.warn "cudaPackages.cudatoolkit is deprecated, refer to the manual and use splayed packages instead" backendCC;
  };

  meta = {
    description = "Wrapper substituting the deprecated runfile-based CUDA installation";
    mainProgram = "nvcc";
    license = lib.licenses.nvidiaCudaRedist;
    teams = [ lib.teams.cuda ];
    outputsToInstall = [ "out" ];
  };
}
