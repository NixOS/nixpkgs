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
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    tag = "v${version}";
    hash = "sha256-DP0dFDXaa0PyaERmhL6dNCOpiNs+N7ojMIapcajfMrk=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "orjson"
  ];

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
