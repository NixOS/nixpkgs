{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  pdm-backend,
  uv-dynamic-versioning,

  # optional-dependencies
  pip,
  platformdirs,
  wheel,

  # tests
  griffe,
  jsonschema,
  mkdocstrings,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "griffelib";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = finalAttrs.version;
    hash = "sha256-hNKL86LSE9PwIofxt2t5PrlThiX7hTgYADK2HDVhNjk=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/griffelib";

  build-system = [
    hatchling
    pdm-backend
    uv-dynamic-versioning
  ];

  optional-dependencies.pypi = [
    pip
    platformdirs
    wheel
  ];

  pythonImportsCheck = [
    "griffe"
  ];

  nativeCheckInputs = [
    griffe
    jsonschema
    mkdocstrings
    pytestCheckHook
  ];

  disabledTestPaths = [
    # missing griffecli
    "tests/test_api.py"
    "tests/test_git.py"
  ];

  meta = {
    changelog = "https://github.com/mkdocstrings/griffe/releases/tag/${finalAttrs.src.tag}";
    description = "Signatures for entire Python programs. Extract the structure, the frame, the skeleton of your project, to generate API documentation or find breaking changes in your API";
    homepage = "https://github.com/mkdocstrings/griffe";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
