{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, aresponses
, coverage
, mypy
, poetry-core
, pydantic
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
  version = "0.5.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    rev = "v${version}";
    sha256 = "sha256-kq4cML7D9XC/QRPjGfaWcs0H78OOc2IXGua7qJpWYOQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    cattrs
    pydantic
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
