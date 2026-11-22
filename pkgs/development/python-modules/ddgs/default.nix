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
  trio,
  uvicorn,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ddgs";
  version = "9.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R2kk6tGzHJjxeh/6TfeID11ChwABQo+Kjhv/itKsfD4=";
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
    dht = [
      fastapi
      uvicorn
      trio
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
