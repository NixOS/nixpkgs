{ buildPythonPackage
, fetchFromGitHub
, lib
, setuptools
, aiofiles
, click
, h2
, httpx
, lxml
, requests
, socksio
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
  version = "3.9.4";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-R96ezs0INIZAXTcD1eWXuj4MSJvCbtbgzgC3ls7wYyI=";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

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

  pythonImportsCheck = [ "duckduckgo_search" ];

  meta = {
    description = "A python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    homepage = "https://github.com/deedy5/duckduckgo_search";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
