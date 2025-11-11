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
  version = "1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flying-sheep";
    repo = "legacy-api-wrap";
    tag = "v${version}";
    hash = "sha256-UvOkVNtH3MbD+ExF0dQ+XAfDx9v7YD3GCNUsEaH7zzM=";
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
