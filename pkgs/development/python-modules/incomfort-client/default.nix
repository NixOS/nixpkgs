{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "incomfort-client";
  version = "0.6.3-1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "incomfort-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-I6MAFvODkw2QadzXJacFl/TwA6exfBB1PSDslmT7Ysw=";
  };

  build-system = [ setuptools ];

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
    changelog = "https://github.com/jbouwh/incomfort-client/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
