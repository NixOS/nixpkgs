{
  lib,
  buildPythonPackage,
  colorama,
  griffelib,
  hatchling,
  pdm-backend,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "griffecli";
  pyproject = true;

  inherit (griffelib) version src;

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
