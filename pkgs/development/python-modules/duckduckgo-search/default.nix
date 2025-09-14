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
  version = "9.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "ddgs";
    tag = "v${version}";
    hash = "sha256-Pwl6fCEBj+eUXYEf4wCTw1fpKZh3j4IVC6SW0Vqcmf4=";
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
