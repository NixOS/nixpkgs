{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-parametrization";
  version = "2021.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "singular-labs";
    repo = "parametrization";
    rev = "refs/tags/${version}";
    hash = "sha256-+8iwGiZBwKshvOklbdv5hOqw474bwZ7L0n6BDOxjJjk=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "parametrization" ];

  meta = {
    description = "Simpler PyTest Parametrization Resources";
    homepage = "https://github.com/singular-labs/parametrization";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
