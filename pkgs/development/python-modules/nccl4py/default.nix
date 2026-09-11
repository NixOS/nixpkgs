{
  lib,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  cuda-core,
  cuda-pathfinder,
  numpy,
  nvidia-cutlass-dsl,
  packaging,

  # passthru
  runCommand,
  python,
}:

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "nccl4py";
  # `nccl4py` is versioned independently of `nccl` and should be the same as the contents of
  # `${cudaPackages.nccl.src}/bindings/nccl4py/nccl/core/_version.py`
  version = "0.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    tag = "nccl4py-v${finalAttrs.version}";
    hash = "sha256-f9hOqRJSC/tuRUAN6qKRaItHR62dG7mu1rtw9nJQhic=";
  };
  sourceRoot = "${finalAttrs.src.name}/bindings/nccl4py";

  postPatch = ''
    substituteInPlace nccl/bindings/_internal/nccl_linux.pyx \
      --replace-fail \
        'from cuda.pathfinder import load_nvidia_dynamic_lib' \
        'from posix.dlfcn cimport dlopen, RTLD_GLOBAL, RTLD_NOW' \
      --replace-fail \
        'cdef uintptr_t handle = load_nvidia_dynamic_lib("nccl")._handle_uint' \
        'cdef uintptr_t handle = <uintptr_t>dlopen("${lib.getLib cudaPackages.nccl}/lib/libnccl.so.2", RTLD_NOW | RTLD_GLOBAL)'
  '';

  build-system = [
    cython
    setuptools
  ];

  env = {
    # `${sourceRoot}/setup.py` insists on reading only from $CUDA_HOME/include
    CUDA_HOME = (lib.getInclude cudaPackages.cuda_cudart).outPath;
    # Since `cudaPackages.nccl` is used as a byte string, it gets compressed and no dependency is
    # created.
    # Disable string compression for Nix to correctly detect the dependency.
    NIX_CFLAGS_COMPILE = "-DCYTHON_COMPRESS_STRINGS=0";
  };

  buildInputs =
    lib.optionals (cudaPackages.cudaOlder "13.0") [
      cudaPackages.cuda_nvcc
    ]
    ++ lib.optionals (cudaPackages.cudaAtLeast "13.0") [
      cudaPackages.cuda_crt
    ];

  dependencies = [
    cuda-core
    cuda-pathfinder
    numpy
    nvidia-cutlass-dsl
    packaging
  ];

  pythonImportsCheck = [
    "nccl"
    "nccl.bindings"
  ];

  passthru.tests = {
    # Ensure that `libnccl` is found outside of the build sandbox.
    import-clean-env =
      runCommand "import-clean-env-nccl4py"
        {
          nativeBuildInputs = [ (python.withPackages (_: [ finalAttrs.finalPackage ])) ];
        }
        ''
          LD_LIBRARY_PATH="${lib.getLib cudaPackages.cuda_cudart}/lib/stubs" \
              python -c 'from nccl.bindings import nccl; print(nccl.get_version())'
          touch $out
        '';
  };

  # Upstream doesn't ship any tests.
  doCheck = false;

  meta = {
    description = "Python bindings for NCCL";
    homepage = "https://github.com/NVIDIA/nccl/blob/master/bindings/nccl4py/README.md";
    changelog = "https://github.com/NVIDIA/nccl/releases/tag/${finalAttrs.src.tag}";
    # `cudaPackages.nccl` is BSD3 but the bindings are licensed under
    # Apache License 2.0
    license = lib.licenses.bsd3;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [
      GaetanLepage
      thefossguy
    ];
    inherit (cudaPackages.nccl.meta) platforms badPlatforms;
  };
})
