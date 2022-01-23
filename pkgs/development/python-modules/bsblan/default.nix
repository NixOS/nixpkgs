{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, aresponses
, coverage
, mypy
, pytest-asyncio
, pytest-cov
, pytest-mock
, pythonOlder
, aiohttp
, attrs
, cattrs
, yarl
}:

buildPythonPackage rec {
  pname = "bsblan";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    rev = "v.${version}";
    sha256 = "1j41y2njnalcsp1vjqwl508yp3ki82lv8108ijz52hprhrq4fffb";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    cattrs
    yarl
  ];

  checkInputs = [
    aresponses
    coverage
    mypy
    pytest-asyncio
    pytest-cov
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bsblan"
  ];

  meta = with lib; {
    description = "Python client for BSB-Lan";
    homepage = "https://github.com/liudger/python-bsblan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
