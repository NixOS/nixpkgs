{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  einops,
  torch,

  # tests
  pytestCheckHook,
  transformers,
  writableTmpDirAsHomeHook,

  # passthru
  fla-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "fla-core";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fla-org";
    repo = "flash-linear-attention";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S09FoA3t1xnFKLimzqqcUKOJpuWHLXwq6dk3SIO1q9c=";
  };

  # Upstream publishes two packages from the same repo: fla-core (fla/{ops,modules,utils}) and
  # flash-linear-attention (fla/{layers,models}). scripts/build_packages.py generates both trees.
  postPatch = ''
    python -c "import sys; sys.path.insert(0, 'scripts'); import build_packages; build_packages.build_split_packages('split')"
    cd split/fla-core
  '';

  build-system = [ setuptools ];

  dependencies = [
    einops
    # Upstream only lists torch (and triton) in backend-specific extras (cuda, cpu, etc.).
    # triton is propagated by torch.
    torch
  ];

  pythonImportsCheck = [
    "fla"
    "fla.ops"
    "fla.modules"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    transformers
    # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
    writableTmpDirAsHomeHook
  ];

  # Run the tests from the repo root against the installed package
  preCheck = ''
    cd "$NIX_BUILD_TOP/$sourceRoot"
    rm -rf fla split
  '';

  # The full test suite takes hours: only run a few representative tests.
  # Note: tests requiring fla.layers / fla.models (e.g. tests/ops/test_deltaformer.py, as
  # fla.ops.deltaformer imports fla.layers.utils) can only run in flash-linear-attention.
  enabledTestPaths = [
    "tests/modules/test_l2norm.py::test_l2norm"
    "tests/modules/test_layernorm.py::test_rmsnorm"
    "tests/modules/test_rotary.py::test_rotary"
    "tests/ops/test_gdn.py::test_chunk_varlen"
    "tests/ops/test_gla.py::test_chunk_varlen"
    "tests/ops/test_simple_gla.py::test_chunk_varlen"
    "tests/utils/test_import.py"
  ];

  # Tests require a GPU
  doCheck = false;
  passthru.gpuCheck = fla-core.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Core operations for flash-linear-attention";
    homepage = "https://github.com/fla-org/flash-linear-attention";
    changelog = "https://github.com/fla-org/flash-linear-attention/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    teams = [ lib.teams.cuda ];
  };
})
