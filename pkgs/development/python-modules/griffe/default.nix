{
  lib,
  aiofiles,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  git,
  griffecli,
  griffelib,
  hatchling,
  jsonschema,
  pdm-backend,
  pytest-gitconfig,
  pytestCheckHook,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "griffe";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = finalAttrs.version;
    hash = "sha256-Fxa9lrBVQ/enVLiU7hUc0d5x9ItI19EGnbxa7MX6Plc=";
  };

  build-system = [
    hatchling
    pdm-backend
    uv-dynamic-versioning
  ];

  dependencies = [
    colorama
    griffecli
    griffelib
  ];

  nativeCheckInputs = [
    git
    jsonschema
    pytest-gitconfig
    pytestCheckHook
  ];

  pythonImportsCheck = [ "griffe" ];

  disabledTestPaths = [
    # Circular dependencies
    "tests/test_api.py"
  ];

  meta = {
    description = "Signatures for entire Python programs";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "griffe";
  };
})
