{ lib
, aiohttp
, auth0-python
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyjwt
, pytest-aiohttp
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiobiketrax";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "basilfx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jZBs1h+01Mbwpvy3hg5/DEIU5EPKW4P/iMqp4eb4EpM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    auth0-python
    python-dateutil
    pyjwt
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiobiketrax"
  ];

  meta = with lib; {
    description = "Library for interacting with the PowUnity BikeTrax GPS tracker";
    homepage = "https://github.com/basilfx/aiobiketrax";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
