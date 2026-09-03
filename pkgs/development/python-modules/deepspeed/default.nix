{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  symlinkJoin,
  cudaPackages,
  llvmPackages,

  # build-system
  setuptools,
  torch,

  # dependencies
  einops,
  hjson,
  msgpack,
  ninja,
  numpy,
  packaging,
  psutil,
  py-cpuinfo,
  pydantic,
  tqdm,
  # cuda-only:
  nvidia-ml-py,
  # cupy,
  # cutlass,

  # tests
  accelerate,
  addBinToPathHook,
  pytest-xdist,
  pytestCheckHook,
  tabulate,
  transformers,
  writableTmpDirAsHomeHook,
}:

let
  inherit (torch) cudaCapabilities cudaSupport;

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist";
    paths = with cudaPackages; [
      (lib.getDev cuda_cudart)
      (lib.getLib cuda_cudart)
      (lib.getStatic cuda_cudart)
      (lib.getBin cuda_nvcc)
    ];
  };
in

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "deepspeed";
  version = "0.19.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepspeedai";
    repo = "DeepSpeed";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ospqxEo/UVt9eRolFZkNKnNnG02I+LWpEKXXJvjrH6Q=";
  };

  patches = lib.optionals stdenv.cc.isClang [
    # The CPU op builders compile with `-fopenmp` but never link the OpenMP runtime.
    # GCC implies `-lgomp`, clang does not, so the JIT-built ops fail to `dlopen`:
    # "symbol not found in flat namespace '___kmpc_end_serialized_parallel'".
    ./darwin-link-libomp.patch
  ];

  postPatch = ''
    substituteInPlace deepspeed/ops/op_builder/builder.py \
      --replace-fail \
        'import distutils' \
        'import setuptools._distutils'
  ''
  # `setup.py` appends `+{git_hash}` (here, `+unknown`) to the version unless `build.txt` exists,
  # in which case its content is appended instead.
  + ''
    touch build.txt
  ''
  +
    lib.optionalString stdenv.hostPlatform.isDarwin
      # DeepSpeed probes for MPS by calling `torch.mps.current_allocated_memory()`, which segfaults
      # when no Metal device is available (as in the sandbox).
      # Use `torch.mps.is_available()`, which now exists, as upstream's own comment asks for.
      ''
        substituteInPlace accelerator/real_accelerator.py \
          --replace-fail \
            "torch.mps.current_allocated_memory()" \
            "if not torch.mps.is_available(): raise RuntimeError('MPS is not available')"
      ''
  + lib.optionalString cudaSupport (
    # Hardcode CUDA_HOME to nix store path for JIT op compilation at runtime
    ''
      substituteInPlace deepspeed/ops/op_builder/builder.py \
        --replace-fail \
          "cuda_home = torch.utils.cpp_extension.CUDA_HOME" \
          "cuda_home = '${cuda-native-redist}'"
    ''
    # Hardcode CUTLASS_PATH to nix store path
    + ''
      substituteInPlace deepspeed/ops/op_builder/evoformer_attn.py \
        --replace-fail \
          'self.cutlass_path = os.environ.get("CUTLASS_PATH")' \
          'self.cutlass_path = "${lib.getInclude cudaPackages.cutlass}/include/cutlass"'
    ''
  );

  build-system = [
    setuptools
    torch
  ];

  # `deepspeed.ops.transformer.inference.triton` creates its autotune cache directory
  # (`$TRITON_HOME`, defaulting to `$HOME/.triton`) at import time.
  preBuild = ''
    export TRITON_HOME=$(mktemp -d)
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  dependencies = [
    einops
    hjson
    msgpack
    ninja
    numpy
    packaging
    psutil
    py-cpuinfo
    pydantic
    torch
    tqdm
  ]
  ++ lib.optionals cudaSupport [
    nvidia-ml-py
  ];

  env = lib.optionalAttrs cudaSupport {
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" cudaCapabilities;
  };

  preCheck = ''
    rm -rf deepspeed
  ''
  # Tests JIT-compile CPU ops, and the op builder pairs the ISA it detects (`-D__AVX512__`) with
  # `-march=native`, which the cc wrapper strips. Let it through, otherwise the intrinsics fail to
  # compile: "inlining failed in call to 'always_inline'".
  + ''
    export NIX_ENFORCE_NO_NATIVE=0
  '';

  pythonImportsCheck = [ "deepspeed" ];

  nativeCheckInputs = [
    accelerate
    addBinToPathHook # Tests run the deepspeed CLI
    ninja
    pytest-xdist
    pytestCheckHook
    tabulate
    transformers
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    # Tests memory consumption grows significantly with the number of parallel processes
    # -> Limit the number of parallel jobs to prevent OOMing
    "--maxprocesses=16"
  ];

  enabledTestPaths = [
    # The test suite seems to be very resource intensive. We stick to unit tests for now.
    "tests/unit/"
  ];

  disabledTestPaths = [
    # Require unpackaged `mup`
    "tests/unit/runtime/test_mup_optimizers.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # KeyError: 'vendor_id_raw'
    "tests/unit/ops/adam/test_cpu_adam.py"
    "tests/unit/ops/adam/test_hybrid_adam.py"
    "tests/unit/ops/lion/test_cpu_lion.py"
  ];

  disabledTests = [
    # AssertionError: assert 2 == 1
    # +  where 2 = len(['[pinned-memory checkpoint] crossed 32.000 GB: 33.000 GB pinned across 1 ...
    "test_checkpoint_emits_info"

    # Fixture handling is incompatible with pytest >= 8.4, upstream pins pytest < 8.4:
    # https://github.com/deepspeedai/DeepSpeed/pull/7327
    "TestDistributedFixture"
    "TestZeROElasticCheckpoint"
    "TestZeROPPLoadCheckpoint"
    "TestZeROUniversalCheckpointDP"

    # Fail since we patch the cutlass/cuda path logic
    "test_include_paths_accepts_cutlass_include_dir_directly"
    "test_include_paths_finds_cutlass_from_cmake_prefix_path"
    "test_include_paths_finds_cutlass_from_compiler_include_path"
    "test_include_paths_finds_python_package_candidate_without_env"
    "test_include_paths_reports_missing_cutlass"
    "test_include_paths_uses_cutlass_path_env"
    "test_installed_cuda_version_reports_a_runtime_only_cuda_home_as_missing"

    # Too long
    "TestWarmupCosineLR"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "TestDistInferenceAllReduce"
    "TestDistInferenceAllReduce"
    "test_apply_rotary_pos_emb_grad_flow"
    "test_on_device"
    "test_save_tensor_clone"
    "test_subclass_param_init"
  ];

  # Most tests spin up a distributed process group over loopback
  __darwinAllowLocalNetworking = true;

  # Some python tests are skipped unless a GPU is visible
  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs {
    requiredSystemFeatures = [ "cuda" ];
  };

  meta = {
    description = "Deep learning optimization library that makes distributed training and inference easy, efficient, and effective";
    homepage = "https://www.deepspeed.ai/";
    downloadPage = "https://github.com/deepspeedai/deepspeed";
    changelog = "https://github.com/deepspeedai/DeepSpeed/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "deepspeed";
    maintainers = with lib.maintainers; [ jlesquembre ];
    teams = [ lib.teams.cuda ];
  };
})
