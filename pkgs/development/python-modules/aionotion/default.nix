{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aionotion";
  version = "2021.10.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-5bu2XveDi2e6lGdI/T+0apqXzcnqdztVtaHEpp+Vkzs=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples" ];

  pythonImportsCheck = [ "aionotion" ];

  meta = with lib; {
    description = "Python library for Notion Home Monitoring";
    homepage = "https://github.com/bachya/aionotion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
