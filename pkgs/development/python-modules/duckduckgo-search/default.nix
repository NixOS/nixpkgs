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
  version = "6.3.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-NvFoiyoXeNOrynGN+VHVfIA3+D9zfAWFeWEVU8/TkZQ=";
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
    changelog = "https://github.com/deedy5/duckduckgo_search/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
