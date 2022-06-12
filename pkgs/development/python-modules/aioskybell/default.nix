{ lib
, aiofiles
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioskybell";
  version = "22.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VaG8r4ULbjI7LkIPCit3bILZgOi9k7ddRQXwVzplaCM=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiofiles
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioskybell"
  ];

  meta = with lib; {
    description = "API client for Skybell doorbells";
    homepage = "https://github.com/tkdrob/aioskybell";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
