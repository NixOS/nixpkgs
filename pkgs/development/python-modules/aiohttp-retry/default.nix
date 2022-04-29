{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-aiohttp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-retry";
  version = "2.5.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "inyutin";
    repo = "aiohttp_retry";
    rev = "v${version}";
    hash = "sha256-jyt4YPn3gSgR1YfHYLs+5VCsjAk9Ij+2m5Kzy51CnLk=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiohttp_retry"
  ];

  meta = with lib; {
    description = "Retry client for aiohttp";
    homepage = "https://github.com/inyutin/aiohttp_retry";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
