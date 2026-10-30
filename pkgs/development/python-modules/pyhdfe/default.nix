{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyhdfe";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeffgortmaker";
    repo = "pyhdfe";
    tag = "v${version}";
    hash = "sha256-ug071o9tMtEWIIdNSNrOWm07Mt6L173aeUIpWBnDiNQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyhdfe" ];

  meta = {
    description = "Python 3 implementation of algorithms for absorbing high dimensional fixed effects";
    homepage = "https://github.com/jeffgortmaker/pyhdfe";
    changelog = "https://github.com/jeffgortmaker/pyhdfe/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
