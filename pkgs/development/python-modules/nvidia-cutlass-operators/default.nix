{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  apache-tvm-ffi,
  networkx,
  nvidia-cutlass-dsl,

  # optional-dependencies
  nvidia-matmul-heuristics,
  torch,
  torch-c-dlpack-ext,

  # tests
  pytestCheckHook,
}:

let
  # Import jax, which isn't packaged here (see optional-dependencies)
  jaxTestPaths = [
    "test/unit/test_reference_check.py"
    "test/integration/test_gemm_jax.py"
  ];

  # Unit tests needing a GPU; passthru.gpuCheck runs them, along with the integration tests
  gpuTestPaths = [
    # Allocate CUDA tensors
    "test/unit/test_allocation.py"
    "test/unit/test_metadata.py"
  ];
  gpuTests = [
    # Queries the CUDA device
    "TestEndToEndRank"
  ];
in
buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-operators";
  # `__version__` of cutlass.operators, which is versioned independently of CUTLASS, so there is no updateScript.
  # Update `version`, `tag` and `hash` together.
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v4.8.0";
    hash = "sha256-FiXSg6DMUAV9Gf5LOePKAwmGLVPxphq6MVwHZwwsKDM=";
  };

  sourceRoot = "${finalAttrs.src.name}/operators";

  build-system = [ setuptools ];

  dependencies = [
    apache-tvm-ffi
    networkx
    nvidia-cutlass-dsl
  ];

  # The jax extra is left out: jax is a large dependency for an alternative frontend.
  optional-dependencies = {
    heuristics = [ nvidia-matmul-heuristics ];
    torch = [
      torch
      torch-c-dlpack-ext
    ];
  };

  # Importing `cutlass.operators` without torch fails: `nvidia-cutlass-dsl` appends its `base_dsl` directory to
  # `sys.path` (`cutlass/base_dsl/compiler.py`), so `importlib.util.find_spec("torch")` finds its internal `torch.py`, and
  # `cutlass.operators.fusion.library` then imports that. torch is how this package is used (its `torch` extra, and
  # PyTorch Inductor's NVGEMM backend), so check the import with it.
  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # `cutlass.operators` is reached through `nvidia-cutlass-dsl`'s `cutlass` package, which adds this
  # distribution's `cutlass/` directory to `cutlass.__path__` (`_APPROVED_CUTLASS_SIBLINGS`).
  pythonImportsCheck = [ "cutlass.operators" ];

  enabledTestPaths = [ "test/unit" ];
  disabledTestPaths = jaxTestPaths ++ gpuTestPaths;
  disabledTests = gpuTests;

  passthru = lib.optionalAttrs torch.cudaSupport {
    gpuCheck = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
      requiredSystemFeatures = [ "cuda" ];

      # Load CUTLASS's own test_sharding plugin (test/utils at the root of the CUTLASS tree, outside sourceRoot), which
      # the operators conftest expects: it implements the `arch` marks (skipping kernels built for other SMs, such as the
      # sm100 block-scaled GEMMs on other GPUs) and the test levels (L0 by default). Without it, the arch marks are
      # unknown and every test runs on every GPU.
      pytestFlags = [
        "-p"
        "test_sharding"
        # test/unit and test/integration both contain test_heuristics.py; upstream's CI uses importlib mode as well.
        "--import-mode=importlib"
      ];

      preCheck =
        (prevAttrs.preCheck or "")
        + (
          ''
            chmod -R u+w ../test/utils
          ''
          # pytest 9 moved running_on_ci from _pytest.assertion.util to _pytest.compat
          + ''
            patch -p1 -d .. < ${./test-sharding-pytest-9.patch}
            export PYTHONPATH="$PWD/../test/utils''${PYTHONPATH:+:$PYTHONPATH}"
          ''
          # The plugin selects tests for the GPU's compute capability; the device_info module it would otherwise query
          # isn't part of the release.
          + ''
            appendToVar pytestFlags "--target-cc=$(python -c 'import torch; print("%d%d" % torch.cuda.get_device_capability())')"
          ''
        );

      enabledTestPaths = [
        "test/unit"
        "test/integration"
      ];
      disabledTestPaths = jaxTestPaths ++ [
        # Executes the example notebooks with Jupyter
        "test/integration/test_notebooks.py"

        # Asserts host-side launch overhead stays under wall-clock thresholds
        "test/integration/test_overhead.py"
      ];
      disabledTests = [ ];
    });
  };

  meta = {
    description = "High-level discover/compile/execute API for CUTLASS Python kernels";
    homepage = "https://github.com/NVIDIA/cutlass/tree/main/operators";
    changelog = "https://github.com/NVIDIA/cutlass/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      connorbaker
    ];
    teams = [ lib.teams.cuda ];
    platforms = lib.platforms.linux;
  };
})
