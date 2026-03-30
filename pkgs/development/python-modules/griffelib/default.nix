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
}:

buildPythonPackage (finalAttrs: {
  pname = "griffelib";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = finalAttrs.version;
    hash = "sha256-8lrpIlWuf9/4Lm+YWLC6GHKwRE7vh+lqBIJIO/WnnSg=";
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

  meta = {
    changelog = "https://github.com/mkdocstrings/griffe/releases/tag/${finalAttrs.src.tag}";
    description = "Signatures for entire Python programs. Extract the structure, the frame, the skeleton of your project, to generate API documentation or find breaking changes in your API";
    homepage = "https://github.com/mkdocstrings/griffe";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
