{ buildPythonPackage
, fetchFromGitHub
, lib
, setuptools
<<<<<<< HEAD
, aiofiles
, click
, h2
, httpx
, lxml
, requests
, socksio
=======
, requests
, click
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "duckduckgo-search";
<<<<<<< HEAD
  version = "3.8.5";
=======
  version = "2.8.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FOGMqvr5+O3+UTdM0m1nJBAcemP6hpAOXv0elvnCUHU=";
=======
    hash = "sha256-UXh3+kBfkylt5CIXbYTa/vniEETUvh4steUrUg5MqYU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
<<<<<<< HEAD
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
=======
    requests
    click
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [ "duckduckgo_search" ];

  meta = {
    description = "A python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    homepage = "https://github.com/deedy5/duckduckgo_search";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
