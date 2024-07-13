{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pyreqwest-impersonate,

  # Optional dependencies
  lxml,
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
  version = "6.1.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = "v${version}";
    hash = "sha256-hw6fe0SDywBQ8k6gpkTVxdJW5AQUk+GY2qoou0JzTlo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    pyreqwest-impersonate
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
