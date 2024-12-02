{
  absl-py,
  buildPythonPackage,
  contextlib2,
  fetchFromGitHub,
  fetchurl,
  lib,
  pyyaml,
  six,
  setuptools,
  flit-core,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "ml-collections";
  version = "1.0.0";
  pyproject = true;
  build-system = [ flit-core ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "ml_collections";
    rev = "refs/tags/v${version}";
    hash = "sha256-QUhwkfffjA6gKd6lTmEgnnoUeJOu82mfFPBta9/iebg=";
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

  pytestFlagsArray = [
    "ml_collections/"
    "--ignore=ml_collections/config_dict/examples/examples_test.py" # From github workflows
  ];

  pythonImportsCheck = [ "ml_collections" ];

  meta = {
    description = "ML Collections is a library of Python collections designed for ML usecases";
    homepage = "https://github.com/google/ml_collections";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
