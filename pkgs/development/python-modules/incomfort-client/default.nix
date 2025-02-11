{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "incomfort-client";
  version = "0.6.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "incomfort-client";
    tag = "v${version}";
    hash = "sha256-ySE2J6h1EeoN7/Y3OK6mrDrXivv9saq9ghHEFGlVlQw=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "incomfortclient" ];

  meta = with lib; {
    description = "Python module to poll Intergas boilers via a Lan2RF gateway";
    homepage = "https://github.com/zxdavb/incomfort-client";
    changelog = "https://github.com/jbouwh/incomfort-client/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
