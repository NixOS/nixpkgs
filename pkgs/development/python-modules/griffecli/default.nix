{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  griffelib,
  hatchling,
  pdm-backend,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "griffecli";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = finalAttrs.version;
    hash = "sha256-hNKL86LSE9PwIofxt2t5PrlThiX7hTgYADK2HDVhNjk=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/griffecli";

  build-system = [
    hatchling
    pdm-backend
    uv-dynamic-versioning
  ];

  dependencies = [
    colorama
    griffelib
  ];

  pythonImportsCheck = [ "griffecli" ];

  meta = {
    description = "Signatures for entire Python programs. Extract the structure, the frame, the skeleton of your project, to generate API documentation or find breaking changes in your API";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
})
