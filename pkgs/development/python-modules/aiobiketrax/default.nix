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
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "basilfx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-P8BExzL22rRj1IFPpojKR8ITdVq0RF8e3qLgb+H1PzE=";
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
