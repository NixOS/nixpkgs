{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  poetry-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "incomfort-client";
  version = "0.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "incomfort-client";
    tag = "v${version}";
    hash = "sha256-+RSKmWVNLiI/NzfbM/xu+/sCNYvkZ2l/AE5TwnF4RCc=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
