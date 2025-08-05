{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  primp,
  lxml,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ddgs";
  version = "9.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${version}";
    hash = "sha256-8OGO70J/o6oUfgdMKgZOtmOf4Nenk3VcV8kxU6UnEFQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    primp
    lxml
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  pythonImportsCheck = [ "ddgs" ];

  meta = {
    description = "D.D.G.S. | Dux Distributed Global Search. A metasearch library that aggregates results from diverse web search services";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/ddgs";
    changelog = "https://github.com/deedy5/ddgs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
