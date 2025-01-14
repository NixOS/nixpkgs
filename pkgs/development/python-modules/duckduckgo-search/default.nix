{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  primp,

  # Optional dependencies
  lxml,
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
  version = "6.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-5AuPAv78ePrnCr5L4CfIu/fq7Ha19zC78zg8JLu3U2A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    primp
  ];

  optional-dependencies = {
    lxml = [ lxml ];
  };

  doCheck = false; # tests require network access

  pythonImportsCheck = [ "duckduckgo_search" ];

  meta = {
    description = "Python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/duckduckgo_search";
    changelog = "https://github.com/deedy5/duckduckgo_search/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
