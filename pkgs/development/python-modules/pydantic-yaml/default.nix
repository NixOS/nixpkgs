{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  hatchling,
  hatch-vcs,

  # dependencies
  pydantic,
  ruamel-yaml,
  typing-extensions,

  # test dependencies
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-yaml";
  version = "1.8.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NowanIlfideme";
    repo = "pydantic-yaml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H4qRYfAGDUhD0pHb+Z5Pi13sXyxv6x+JnW7zPNYHW4s=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pydantic
    ruamel-yaml
    typing-extensions
  ];

  pythonImportsCheck = [ "pydantic_yaml" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pydantic/pydantic-core/releases/tag/${finalAttrs.src.tag}";
    description = "YAML reading/writing for Pydantic models";
    homepage = "https://github.com/NowanIlfideme/pydantic-yaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
