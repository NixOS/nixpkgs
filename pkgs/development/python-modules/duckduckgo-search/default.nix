{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  primp,
  lxml,
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
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

  doCheck = false; # tests require network access

  pythonImportsCheck = [ "ddgs" ];

  meta = {
    description = "Python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/ddgs";
    changelog = "https://github.com/deedy5/ddgs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
