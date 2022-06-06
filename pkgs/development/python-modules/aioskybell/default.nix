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
  version = "22.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    hash = "sha256-2AsEVGZ4cA1GeoxtGFuvjZ05W4FjQ5GFSM8euu9iY4s==";
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
