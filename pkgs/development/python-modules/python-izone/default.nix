{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, netifaces
, pytest-aio
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-izone";
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    rev = "v${version}";
    hash = "sha256-HV8aQlwJ7VbGlJU0HpS9fK/QnRfYrk4ijKTGPWj0Jww=";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
  ];

  checkInputs = [
    pytest-aio
    pytest-asyncio
    pytestCheckHook
  ];

  doCheck = false; # most tests access network

  pythonImportsCheck = [
    "pizone"
  ];

  meta = with lib; {
    description = "Python interface to the iZone airconditioner controller";
    homepage = "https://github.com/Swamp-Ig/pizone";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
