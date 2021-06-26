{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, netifaces
, asynctest
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-izone";
  version = "1.1.6";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    rev = "v${version}";
    sha256 = "sha256-zgE1ccEPSa9nX0SEMN02VEGfnHexk/+jCJe7ugUL5UA=";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pizone" ];

  meta = with lib; {
    description = "A python interface to the iZone airconditioner controller";
    homepage = "https://github.com/Swamp-Ig/pizone";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
