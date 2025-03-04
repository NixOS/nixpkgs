{
  aiofiles,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  lxml,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiowebdav2";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "aiowebdav2";
    tag = "v${version}";
    hash = "sha256-421c/3UYq/xtv5Zm4j2dje1KH2HOvPrVlmfMA4NX4pA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    aiohttp
    lxml
    python-dateutil
    yarl
  ];

  pythonImportsCheck = [ "aiowebdav2" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jpbede/aiowebdav2/releases/tag/${src.tag}";
    description = "Async Python 3 client for WebDAV";
    homepage = "https://github.com/jpbede/aiowebdav2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
