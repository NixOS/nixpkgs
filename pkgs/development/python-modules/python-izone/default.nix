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
  version = "1.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    rev = "v${version}";
    sha256 = "sha256-/qPWSTO0PV4lEgwWpgcoBnbUtDUrEVItb4NF9TV2QJU=";
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

  disabledTestPaths = [
    # Test are blocking
    "tests/test_fullstack.py"
  ];

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
