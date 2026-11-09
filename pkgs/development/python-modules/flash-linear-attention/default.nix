{
  lib,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  fla-core,
  transformers,

  # optional-dependencies
  tilelang,
  causal-conv1d,
  pandas,
  matplotlib,
  datasets,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  flash-linear-attention,
}:

buildPythonPackage (finalAttrs: {
  pname = "flash-linear-attention";
  inherit (fla-core) version src;
  pyproject = true;

  # Only ships fla/{layers,models}. The rest of `fla` is provided by fla-core.
  postPatch = ''
    python -c "import sys; sys.path.insert(0, 'scripts'); import build_packages; build_packages.build_split_packages('split')"
    cd split/flash-linear-attention
  '';

  build-system = [ setuptools ];

  dependencies = [
    fla-core
    transformers
  ];

  optional-dependencies = {
    tilelang = [ tilelang ];
    conv1d = [ causal-conv1d ];
    benchmark = [
      matplotlib
      pandas
      datasets
    ];
  };

  pythonImportsCheck = [
    "fla"
    "fla.layers"
    "fla.models"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # torch._inductor.exc.InductorError: PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
    writableTmpDirAsHomeHook
  ];

  # Run the tests from the repo root against the installed package
  preCheck = ''
    cd "$NIX_BUILD_TOP/$sourceRoot"
    rm -rf fla split
  '';

  # The full test suite takes hours: only run a few representative tests.
  enabledTestPaths = [
    "tests/layers/test_gated_deltanet.py"
    "tests/models/test_cache.py::test_crop"
    "tests/models/test_cache.py::test_pickle"
    "tests/models/test_cache.py::test_reset"
    "tests/models/test_generation.py::test_generate"
    "tests/models/test_modeling_gated_deltanet.py::test_generation"
    "tests/models/test_modeling_gated_deltanet.py::test_modeling"
    "tests/models/test_modeling_gla.py::test_generation"
    "tests/modules/test_conv.py::test_conv"
  ];

  # Tests require a GPU
  doCheck = false;
  passthru.gpuCheck = flash-linear-attention.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Triton-based implementations of causal linear attention";
    homepage = "https://github.com/fla-org/flash-linear-attention";
    changelog = "https://github.com/fla-org/flash-linear-attention/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
    teams = [ lib.teams.cuda ];
  };
})
