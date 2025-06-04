{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  click,
  primp,

  # Optional dependencies
  lxml,
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
  version = "8.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    tag = "v${version}";
    hash = "sha256-Hbhrm++F6aVvJ//WAgyLNsJe+KS0cjnQ83I1ba72Ows=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    primp
  ] ++ optional-dependencies.lxml;

  optional-dependencies = {
    lxml = [ lxml ];
  };

  doCheck = false; # tests require network access

  pythonImportsCheck = [ "duckduckgo_search" ];

  meta = {
    description = "Python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/duckduckgo_search";
    changelog = "https://github.com/deedy5/duckduckgo_search/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
