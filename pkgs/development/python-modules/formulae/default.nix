{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,
  packaging,
  pandas,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "formulae";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "formulae";
    tag = finalAttrs.version;
    hash = "sha256-b6f1Cddtv7VSEocmO/qBJiZMrD2HseptWZnioLx0wW8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    packaging
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

  meta = {
    homepage = "https://bambinos.github.io/formulae";
    description = "Formulas for mixed-effects models in Python";
    changelog = "https://github.com/bambinos/formulae/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
