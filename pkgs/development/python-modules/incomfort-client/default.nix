{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "incomfort-client";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kdPue3IfF85O+0dgvX+dN6S4WoQmjxdCfwfv83SnO8E=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    aioresponses
    pytest-asyncio
  ];

  pythonImportsCheck = [ "incomfortclient" ];

  meta = with lib; {
    description = "Python module to poll Intergas boilers via a Lan2RF gateway";
    homepage = "https://github.com/zxdavb/incomfort-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
