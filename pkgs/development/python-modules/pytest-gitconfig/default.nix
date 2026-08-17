{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pkgs,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-gitconfig";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noirbizarre";
    repo = "pytest-gitconfig";
    tag = finalAttrs.version;
    hash = "sha256-z3W9AL74i47k/eYCbFMn3foVaD2h7lFrGzyOnbDwkyc=";
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
    changelog = "https://github.com/noirbizarre/pytest-gitconfig/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
