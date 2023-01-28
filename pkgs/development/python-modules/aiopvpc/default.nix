{ lib
, aiohttp
, async-timeout
, backports-zoneinfo
, buildPythonPackage
, fetchFromGitHub
, holidays
, poetry-core
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, tzdata
}:

buildPythonPackage rec {
  pname = "aiopvpc";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "azogue";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eTCQddoZIaCs7iKGNBC8aSq6ek4vwYXgIXx35UlME/k=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    holidays
    tzdata
    async-timeout
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # Failures seem related to changes in holidays-0.13, https://github.com/azogue/aiopvpc/issues/44
    "test_number_of_national_holidays"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      " --cov --cov-report term --cov-report html" ""
  '';

  pythonImportsCheck = [
    "aiopvpc"
  ];

  meta = with lib; {
    description = "Python module to download Spanish electricity hourly prices (PVPC)";
    homepage = "https://github.com/azogue/aiopvpc";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
