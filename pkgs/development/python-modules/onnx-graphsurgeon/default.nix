{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ml-dtypes,
  numpy,
  onnx,

  # tests
  onnxruntime,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "onnx-graphsurgeon";
  # `__version__` of onnx_graphsurgeon, which lives in the TensorRT OSS tree and is versioned independently of it, so
  # nix-update can't update it (see passthru.updateScript). Update `version`, `tag` and `hash` together.
  version = "0.6.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "TensorRT";
    tag = "v11.4";
    # The TensorRT OSS tree is large; only this tool is needed.
    sparseCheckout = [ "tools/onnx-graphsurgeon" ];
    hash = "sha256-MsIrodENshnUX2Rm72SER7XrQS99Ol9F4lnPhTwbfYY=";
  };

  sourceRoot = "${finalAttrs.src.name}/tools/onnx-graphsurgeon";

  build-system = [ setuptools ];

  dependencies = [
    ml-dtypes
    numpy
    onnx
  ];

  pythonImportsCheck = [ "onnx_graphsurgeon" ];

  nativeCheckInputs = [
    onnxruntime
    pytestCheckHook
  ];

  # The tests import their models from tests/onnx_models.py.
  preCheck = ''
    export PYTHONPATH="$PWD/tests''${PYTHONPATH:+:$PYTHONPATH}"
  '';

  disabledTestPaths = [
    # Runs the example scripts, some of which download models
    "tests/test_examples.py"
  ];

  passthru = {
    # The default (nix-update) would set `version` to the TensorRT release.
    updateScript = null;
  };

  meta = {
    description = "Generate, modify and transform ONNX graphs";
    homepage = "https://github.com/NVIDIA/TensorRT/tree/main/tools/onnx-graphsurgeon";
    changelog = "https://github.com/NVIDIA/TensorRT/blob/${finalAttrs.src.tag}/tools/onnx-graphsurgeon/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
  };
})
