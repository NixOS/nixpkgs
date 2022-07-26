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
  version = "1.2.7";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    rev = "v${version}";
    hash = "sha256-CvFOhs56dfNerK3junWElQfTJi1YXA86zMbv0tseQC8=";
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
