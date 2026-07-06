{
  absl-py,
  buildPythonPackage,
  contextlib2,
  fetchFromGitHub,
  lib,
  pyyaml,
  six,
  flit-core,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "ml-collections";
  version = "1.1.0";
  pyproject = true;
  build-system = [ flit-core ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "ml_collections";
    tag = "v${version}";
    hash = "sha256-G9+UBqHalzI3quR8T5NEgJs+ep60ffFw9vyTTZDeZ9M=";
  };

  dependencies = [
    six
    absl-py
    contextlib2
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  enabledTestPaths = [
    "ml_collections/"
  ];

  disabledTestPaths = [
    "ml_collections/config_dict/examples/examples_test.py" # From github workflows
  ];

  pythonImportsCheck = [ "ml_collections" ];

  meta = {
    description = "ML Collections is a library of Python collections designed for ML usecases";
    homepage = "https://github.com/google/ml_collections";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
