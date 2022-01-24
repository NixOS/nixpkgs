{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, aioresponses
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bond-api";
  version = "0.1.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "prystupa";
    repo = "bond-api";
    rev = "v${version}";
    sha256 = "sha256-NmXMN6esX1O8E1pVGK1rbWp/xqrmHCusOs2SsEACDts=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bond_api"
  ];

  meta = with lib; {
    description = "Asynchronous Python wrapper library over Bond Local API";
    homepage = "https://github.com/prystupa/bond-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
