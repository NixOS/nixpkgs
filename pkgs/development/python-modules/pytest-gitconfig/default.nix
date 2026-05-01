{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pkgs,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-gitconfig";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noirbizarre";
    repo = "pytest-gitconfig";
    tag = version;
    hash = "sha256-5DfG74mEvsWHH2xPyG1mNcWp9/DgpveLbaSEOoRzD+g=";
  };

  build-system = [ pdm-backend ];

  buildInput = [ pytest ];

  nativeCheckInputs = [
    pkgs.gitMinimal
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_gitconfig" ];

  meta = {
    description = "Pytest gitconfig sandbox";
    homepage = "https://github.com/noirbizarre/pytest-gitconfig";
    changelog = "https://github.com/noirbizarre/pytest-gitconfig/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
