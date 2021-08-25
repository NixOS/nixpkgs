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
  version = "2.2.0";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "azogue";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hk3giwzzlcqnpw9kx3zrr808nmdb7qwac60fki5395qffd2fpqw";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backports-zoneinfo
    holidays
    tzdata
    async-timeout
  ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      " --cov --cov-report term --cov-report html" ""
  '';

  pythonImportsCheck = [ "aiopvpc" ];

  meta = with lib; {
    description = "Python module to download Spanish electricity hourly prices (PVPC)";
    homepage = "https://github.com/azogue/aiopvpc";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
