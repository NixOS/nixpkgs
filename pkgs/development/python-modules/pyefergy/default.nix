{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, iso4217
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "pyefergy";
  version = "22.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    sha256 = "sha256-AdoM+PcVoajxhnEfkyN9UuNufChu8XGmZDLNC3mjrps=";
  };

  propagatedBuildInputs = [
    aiohttp
    iso4217
    pytz
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyefergy"
  ];

  meta = with lib; {
    description = "Python API library for Efergy energy meters";
    homepage = "https://github.com/tkdrob/pyefergy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
