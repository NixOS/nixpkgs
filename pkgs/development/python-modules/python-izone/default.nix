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
  version = "1.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    rev = "v${version}";
    hash = "sha256-WF37t9vCEIyQMeN3/CWAiiZ5zsMRMFQ5UvMUqfoGM9I=";
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
