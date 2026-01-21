{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "grapheme";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timendum";
    repo = "grapheme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FDQKjxQAW+krUScZKmfv9ytVPIcEKNrbHurXb5wVeIM=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "grapheme"
  ];

  meta = {
    description = "Grapheme";
    homepage = "https://github.com/timendum/grapheme";
    changelog = "https://github.com/timendum/grapheme/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
