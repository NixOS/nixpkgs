{ buildPythonPackage
, fetchFromGitHub
, lib
, setuptools
, requests
, click
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = "v${version}";
    hash = "sha256-UXh3+kBfkylt5CIXbYTa/vniEETUvh4steUrUg5MqYU=";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    click
  ];

  pythonImportsCheck = [ "duckduckgo_search" ];

  meta = {
    description = "A python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    homepage = "https://github.com/deedy5/duckduckgo_search";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
