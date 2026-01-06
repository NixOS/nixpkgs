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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeffgortmaker";
    repo = "pyhdfe";
    tag = "v${version}";
    hash = "sha256-UXVQHf4Nmq/zQZtPaLba4TShhpgPUBwPM+zCEa8qaKs=";
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
