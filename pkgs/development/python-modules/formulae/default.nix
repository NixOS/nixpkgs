{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  numpy,
  pandas,
  scipy,
}:

buildPythonPackage rec {
  pname = "formulae";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "formulae";
    tag = version;
    hash = "sha256-SSyQa7soIp+wSXX5wek9LG95q7J7K34mztzx01lPiWo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    pandas
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # use assertions of form `assert pytest.approx(...)`, which is now disallowed:
    "test_basic"
    "test_degree"
    # AssertionError
    "test_evalenv_equality"
  ];

  pythonImportsCheck = [
    "formulae"
    "formulae.matrices"
  ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/formulae";
    description = "Formulas for mixed-effects models in Python";
    changelog = "https://github.com/bambinos/formulae/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
