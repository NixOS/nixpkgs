{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest,
  mockito,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-mockito";
  version = "0.0.6.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kaste";
    repo = "pytest-mockito";
    rev = version;
    hash = "sha256-zlErrgVeeVNojZfYYACRx/4sDWaub7EN1bCr4IhtMPg=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  buildInputs = [ pytest ];

  dependencies = [ mockito ];

  pythonImportsCheck = [ "pytest_mockito" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Base fixtures for mockito";
    homepage = "https://github.com/kaste/pytest-mockito";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
