{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytomorrowio";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "raman325";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-07S6qttSCBjrSqMaR5wWMvaa2cYKtR31DaKRsKaS8Dw=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytomorrowio"
  ];

  meta = with lib; {
    description = "Python client for Tomorrow.io API";
    homepage = "https://github.com/raman325/pytomorrowio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
