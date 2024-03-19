{ lib
, aiofiles
, buildPythonPackage
, click
, fetchFromGitHub
, h2
, httpx
, lxml
, pythonOlder
, requests
, setuptools
, socksio
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
  version = "5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-OZFkSFyXC2MFP2MbKwF/qR8zvCFzPKgLmX+nuIztOpw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiofiles
    click
    h2
    httpx
    lxml
    requests
    socksio
  ] ++ httpx.optional-dependencies.brotli
    ++ httpx.optional-dependencies.http2
    ++ httpx.optional-dependencies.socks;

  pythonImportsCheck = [
    "duckduckgo_search"
  ];

  meta = with lib; {
    description = "Python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/duckduckgo_search";
    changelog = "https://github.com/deedy5/duckduckgo_search/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
