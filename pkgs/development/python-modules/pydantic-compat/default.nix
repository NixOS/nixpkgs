{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  hatch-vcs,
  hatchling,
  importlib-metadata,
  pydantic,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pydantic-compat";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "pydantic-compat";
    rev = "refs/tags/v${version}";
    hash = "sha256-YJUfWu+nyGlwpJpxYghCKzj3CasdAaqYoNVCcfo/7YE=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    git
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    importlib-metadata
    pydantic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pydantic_compat" ];

  meta = with lib; {
    description = "Compatibility layer for pydantic v1/v2";
    homepage = "https://github.com/pyapp-kit/pydantic-compat";
    changelog = "https://github.com/pyapp-kit/pydantic-compat/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
