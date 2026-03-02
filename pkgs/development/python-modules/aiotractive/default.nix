{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiotractive";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    tag = "v${version}";
    hash = "sha256-pU6Ugd4l9+oUWJAd1hT3oBPfXK5NEjOg+k3YN52C3B8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiotractive" ];

  meta = {
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    changelog = "https://github.com/zhulik/aiotractive/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
