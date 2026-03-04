{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  lxml,
  versionCheckHook,
  primp,
  fastapi,
  mcp,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "ddgs";
  version = "9.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${version}";
    hash = "sha256-eGKS3aXEg0dgtDCTAodMKjT174O1qr1HMUw5Hu8zIuw=";
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
    changelog = "https://github.com/deedy5/ddgs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
