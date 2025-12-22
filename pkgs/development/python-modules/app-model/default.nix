{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  in-n-out,
  psygnal,
  pydantic,
  pydantic-compat,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "app-model";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "app-model";
    tag = "v${version}";
    hash = "sha256-e/CAeeMaMy8uDgI5NuUokWJNUl/H89am2jYJ2AqPiz4=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    psygnal
    pydantic
    pydantic-compat
    in-n-out
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "app_model" ];

  meta = {
    description = "Module to implement generic application schema";
    homepage = "https://github.com/pyapp-kit/app-model";
    changelog = "https://github.com/pyapp-kit/app-model/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
