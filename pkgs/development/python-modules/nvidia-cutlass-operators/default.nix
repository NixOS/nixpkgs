{
  lib,
  buildPythonPackage,
  common-updater-scripts,
  curl,
  fetchFromGitHub,
  writeShellApplication,

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
  # Import jax, which is left out of the optional-dependencies
  jaxTestPaths = [
    "test/unit/test_reference_check.py"
    "test/integration/test_gemm_jax.py"
  ];

  # Unit tests needing a GPU; passthru.gpuCheck runs them, along with the integration tests
  gpuTests = [
    # test/unit/test_allocation.py: allocate CUDA tensors
    "test_distinct_operands_do_not_share_storage"
    "test_distinct_operands_hold_different_data"
    "test_operands_are_uncorrelated_enough_for_exact_accumulation"
    "test_buffer_over_allocates_by_the_offset_bound_not_by_double"
    "test_random_offset_is_bounded_but_still_varies"
    "test_buffer_spans_the_tensor_without_double_counting"
    "test_seed_collision_is_reported_not_silently_accepted"
    # test/unit/test_metadata.py: allocate CUDA tensors
    "test_perfectly_aligned"
    "test_overaligned"
    "test_underaligned"
    "test_ptr_misaligned"
    # test/unit/test_heuristics_nvmatmul.py: queries the CUDA device
    "TestEndToEndRank"
  ];
in
buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-operators";
  # `__version__` of cutlass.operators, which is versioned independently of CUTLASS (passthru.cutlassVersion).
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v${finalAttrs.passthru.cutlassVersion}";
    hash = "sha256-Gc3HqRZGTapmCisThmEQQqbn1NenObxGK/bM0rtKaPg=";
  };

  # Both are open upstream PRs; drop them once a CUTLASS release includes them.
  patches = [
    # Import torch only where the blockscaled GEMM kernels need it, so `import cutlass.operators` works without the torch
    # extra
    # https://github.com/NVIDIA/cutlass/pull/3768
    ./import-torch-only-where-needed.patch
    # pytest 9 moved running_on_ci from _pytest.assertion.util to _pytest.compat (test/utils, used by passthru.gpuCheck)
    # https://github.com/NVIDIA/cutlass/pull/3744
    ./test-sharding-pytest-9.patch
  ];

  # The patches apply to the CUTLASS tree; the package is in operators/.
  postPatch = "cd operators";

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

  # The tests exercise both extras.
  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # `cutlass.operators` is reached through `nvidia-cutlass-dsl`'s `cutlass` package, which adds this
  # distribution's `cutlass/` directory to `cutlass.__path__` (`_APPROVED_CUTLASS_SIBLINGS`).
  pythonImportsCheck = [ "cutlass.operators" ];

  enabledTestPaths = [ "test/unit" ];
  disabledTestPaths = jaxTestPaths;
  disabledTests = gpuTests;

  passthru = {
    # The CUTLASS release the source is taken from
    cutlassVersion = "4.8.1";

    # Follows CUTLASS's releases, and sets `version` to the `__version__` of cutlass.operators at that release. (The
    # default, nix-update, would set `version` to the CUTLASS release.)
    updateScript = lib.getExe (writeShellApplication {
      name = "nvidia-cutlass-operators-updater";
      runtimeInputs = [
        common-updater-scripts
        curl
      ];
      text = ''
        tag="$(list-git-tags --url=${finalAttrs.src.gitRepoUrl} | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort --version-sort | tail -n 1)"
        init="$(curl -fsSL "https://raw.githubusercontent.com/NVIDIA/cutlass/$tag/operators/cutlass/operators/__init__.py")"
        version="$(sed -nE 's/^__version__ = "(.+)"$/\1/p' <<<"$init")"
        update-source-version python3Packages.nvidia-cutlass-operators "''${tag#v}" --version-key=cutlassVersion
        update-source-version python3Packages.nvidia-cutlass-operators "$version" --ignore-same-hash
      '';
    });
  }
  // lib.optionalAttrs torch.cudaSupport {
    gpuCheck = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
      requiredSystemFeatures = [ "cuda" ];

      # Load CUTLASS's own test_sharding plugin (test/utils at the root of the CUTLASS tree, outside sourceRoot), which
      # the operators conftest expects: it implements the `arch` marks, skipping kernels built for other SMs, such as the
      # sm100 block-scaled GEMMs on other GPUs. Without it, the arch marks are unknown and every test runs on every GPU.
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
