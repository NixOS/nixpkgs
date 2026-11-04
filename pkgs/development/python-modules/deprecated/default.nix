{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  wrapt,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deprecated";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laurent-laporte-pro";
    repo = "deprecated";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cW2KHJ5MPyxWtZ792H/Whk0nIcUo1PDNkIzMMQ5d+ao=";
  };

  build-system = [ hatchling ];

  dependencies = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "deprecated" ];

  meta = {
    changelog = "https://github.com/laurent-laporte-pro/deprecated/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/laurent-laporte-pro/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tilpner ];
  };
})
