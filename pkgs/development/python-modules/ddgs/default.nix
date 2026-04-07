{
  buildPythonPackage,
  click,
  fastapi,
  fetchFromGitHub,
  lib,
  lxml,
  mcp,
  primp,
  setuptools,
  uvicorn,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ddgs";
  version = "9.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AUfPAHRrhO/n6hFyXEfG+X4ukCqIMCJbXSss0jYUYiY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    lxml
    primp
  ];

  optional-dependencies = {
    api = [
      fastapi
      uvicorn
    ];
    mcp = [
      mcp
    ];
  };

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  pythonImportsCheck = [ "ddgs" ];

  meta = {
    description = "A metasearch library that aggregates results from diverse web search services";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/ddgs";
    changelog = "https://github.com/deedy5/ddgs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
