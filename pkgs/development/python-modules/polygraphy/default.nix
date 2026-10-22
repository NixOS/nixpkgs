{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # optional-dependencies
  onnx,
  onnx-graphsurgeon,
  onnxruntime,
  tensorrt,

  # tests
  pytestCheckHook,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "polygraphy";
  # `__version__` of polygraphy, which lives in the TensorRT OSS tree and is versioned independently of it, so nix-update
  # can't update it (see passthru.updateScript). Update `version`, `tag` and `hash` together.
  version = "0.53.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "TensorRT";
    tag = "v11.4";
    # The TensorRT OSS tree is large; only this tool is needed.
    sparseCheckout = [ "tools/Polygraphy" ];
    hash = "sha256-uQ+0Hi00oK2oxoN9QLt2nGqzorTuMP362umxYKu8tD4=";
  };

  sourceRoot = "${finalAttrs.src.name}/tools/Polygraphy";

  # The TensorRT 11.3 OSS release dropped setup.py and nothing replaced it.
  postPatch = ''
    cp ${./pyproject.toml} pyproject.toml
  '';

  build-system = [ setuptools ];

  # Upstream declares no dependencies: every module is imported lazily, when a backend needs it. NumPy is needed by all
  # of the backends and comparators.
  dependencies = [ numpy ];

  # Upstream declares no extras; these group the lazily-imported dependencies of the backends.
  optional-dependencies = {
    onnx = [
      onnx
      onnx-graphsurgeon
    ];
    onnxruntime = [ onnxruntime ];
    tensorrt = [ tensorrt ];
  };

  pythonImportsCheck = [
    "polygraphy"
    "polygraphy.tools"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch # the comparator tests also run on torch tensors
    writableTmpDirAsHomeHook
  ];

  # Enables the checks of internal invariants that some tests exercise, as upstream's Makefile does.
  env.POLYGRAPHY_INTERNAL_CORRECTNESS_CHECKS = "1";

  # Most of the test modules (and tests/tools/conftest.py) import tensorrt, which is unfree and needs a GPU for most
  # tests; these modules don't.
  enabledTestPaths = [
    "tests/backend/base/test_loader.py"
    "tests/common/test_interface.py"
    "tests/common/test_struct.py"
    "tests/comparator/test_compare.py"
    "tests/comparator/test_postprocess.py"
    "tests/func/test_func.py"
    "tests/logger/test_logger.py"
    "tests/mod/test_exporter.py"
    "tests/mod/test_util.py"
    "tests/test_deprecated_aliases.py"
  ];

  passthru = {
    # The default (nix-update) would set `version` to the TensorRT release.
    updateScript = null;
  };

  meta = {
    description = "Deep learning inference prototyping and debugging toolkit";
    homepage = "https://github.com/NVIDIA/TensorRT/tree/main/tools/Polygraphy";
    changelog = "https://github.com/NVIDIA/TensorRT/blob/${finalAttrs.src.tag}/tools/Polygraphy/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
    mainProgram = "polygraphy";
  };
})
