{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  tabulate,
  coverage,
  flake8,
  pytest,
  pytestCheckHook,
  fetchpatch,
}:
buildPythonPackage rec {
  pname = "pyquerylist";
  version = "0-unstable-2024-10-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markmuetz";
    repo = "pyquerylist";
    rev = "5fab48f835cda4ed9462b5ad902726ba3d101554";
    hash = "sha256-nwCcGNnKovY/P7tYyyivaMUn+nIYd0968/4cey9tqb8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/markmuetz/pyquerylist/commit/a0f1f1c19b8664a68ae3fe61db566108322954c4.patch";
      hash = "sha256-a7IelYlpIqnL4fauFfeYtEh+JmLgiWjlrlb7fwzDRBc=";
    })
  ];

  propagatedBuildInputs = [
    tabulate
  ];

  pythonImportsCheck = [ "pyquerylist" ];

  nativeCheckInputs = [
    coverage
    flake8
    pytest
    pytestCheckHook
  ];

  build-system = [
    setuptools
    wheel
  ];

  meta = {
    description = "Extension of base Python list that you can query";
    homepage = "https://github.com/markmuetz/pyquerylist";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philipwilk ];
  };
}
