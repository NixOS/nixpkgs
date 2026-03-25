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
  version = "9.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+UefNpWKq1Rcm90M+hQavEORYZF4FWC1FzH7TfAH6WA=";
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
      mcp
      uvicorn
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
