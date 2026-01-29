{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  # dependencies
  astunparse,
  gast,
  termcolor,
  # test
  # pytestCheckHook,
  numpy,
  tensorflow,
  importlib-resources,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "diastatic-malt";
  version = "2.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PennyLaneAI";
    repo = "diastatic-malt";
    tag = "v${version}";
    hash = "sha256-2lQZZWE4DtdeVPOTMLJgEZweYpr95ztswPNf2AH9VDA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    astunparse
    gast
    termcolor
  ];

  pythonImportsCheck = [ "malt" ];

  doCheck = true;

  nativeCheckInputs = [
    # pytest tests depends on deprecated imp library and are therefore broken
    # pytestCheckHook
    numpy
    tensorflow
    importlib-resources
    importlib-metadata
  ];

  meta = {
    homepage = "https://github.com/PennyLaneAI/diastatic-malt";
    description = "Source-to-source transformations and operator overloading";
    teams = [ lib.teams.quantum ];
    license = lib.licenses.asl20;
  };
}
