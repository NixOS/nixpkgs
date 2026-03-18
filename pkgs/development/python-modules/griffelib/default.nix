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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = finalAttrs.version;
    hash = "sha256-SiUkgkaHtq2aWraL5BJvItOExTGUQ+e6pQVXEwTM0mk=";
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
    description = "Signatures for entire Python programs. Extract the structure, the frame, the skeleton of your project, to generate API documentation or find breaking changes in your API";
    homepage = "https://github.com/mkdocstrings/griffe";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
