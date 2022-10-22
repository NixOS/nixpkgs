{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "py-nightscout";
  version = "1.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marciogranzotto";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kslmm3wrxhm307nqmjmq8i8vy1x6mjaqlgba0hgvisj6b4hx65k";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytestCheckHook
    pytest-asyncio
  ];


  pythonImportsCheck = [
    "py_nightscout"
  ];

  meta = with lib; {
    description = "Python library that provides an interface to Nightscout";
    homepage = "https://github.com/marciogranzotto/py-nightscout";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
