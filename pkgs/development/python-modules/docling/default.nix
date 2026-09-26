{
  lib,
  buildPythonPackage,
  docling-slim,

  # build system
  hatchling,

  # tests
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling";
  inherit (docling-slim) version src;
  pyproject = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/packages/docling";

  build-system = [
    hatchling
  ];

  # Meta-package: it ships no Python module of its own, only the console scripts. `docling` itself
  # is provided by docling-slim, which upstream pulls in with the `standard` extra.
  dependencies = [
    docling-slim
  ]
  ++ docling-slim.optional-dependencies.standard;

  pythonImportsCheck = [ "docling" ];

  # No python tests in this subpackage, they all live in docling-slim
  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "SDK and CLI for parsing PDF, DOCX, HTML, and more, to a unified document representation for powering downstream workflows such as gen AI applications";
    homepage = "https://github.com/DS4SD/docling";
    changelog = "https://github.com/DS4SD/docling/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "docling";
  };
})
