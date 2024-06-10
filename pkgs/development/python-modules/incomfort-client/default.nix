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
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HWooJ18aOps+3/zpn1k6tWSOD0DSsTDs0Nm+iHb/p2w=";
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
