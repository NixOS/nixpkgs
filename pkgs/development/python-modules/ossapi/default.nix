{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  osrparse,
  requests,
  requests-oauthlib,
  setuptools,
  typing-utils,
}:

buildPythonPackage rec {
  pname = "ossapi";
  version = "5.3.2";
  pyproject = true;

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "Liam-DeVoe";
=======
    owner = "tybug";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    repo = "ossapi";
    tag = "v${version}";
    hash = "sha256-sLzw/0RsA0PGxxQeVz4TGIpTMMlrZ0i4ZGolrz5S16E=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "osrparse" ];

  dependencies = [
    osrparse
    requests
    requests-oauthlib
    typing-utils
  ];

  optional-dependencies = {
    async = [ aiohttp ];
  };

  # Tests require Internet access and an osu! API key
  doCheck = false;

  pythonImportsCheck = [ "ossapi" ];

  meta = {
    description = "Python wrapper for the osu! API";
<<<<<<< HEAD
    homepage = "https://github.com/Liam-DeVoe/ossapi";
    changelog = "https://github.com/Liam-DeVoe/ossapi/releases/tag/${src.tag}";
=======
    homepage = "https://github.com/tybug/ossapi";
    changelog = "https://github.com/tybug/ossapi/releases/tag/${src.tag}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ wulpine ];
  };
}
