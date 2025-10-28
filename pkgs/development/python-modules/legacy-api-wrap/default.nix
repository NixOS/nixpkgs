{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-docstring-description,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "legacy-api-wrap";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flying-sheep";
    repo = "legacy-api-wrap";
    tag = "v${version}";
    hash = "sha256-ySkhfUyRBd4QS3f46KlaA5NrHxHr+dlkgmD4fGk2KsA=";
  };

  build-system = [
    hatch-docstring-description
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [
    "legacy_api_wrap"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Wrap legacy APIs in python projects";
    homepage = "https://github.com/flying-sheep/legacy-api-wrap";
    changelog = "https://github.com/flying-sheep/legacy-api-wrap/releases/tag/${src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
