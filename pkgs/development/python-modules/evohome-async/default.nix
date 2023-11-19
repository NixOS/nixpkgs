{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "evohome-async";
  version = "0.4.9";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    rev = "refs/tags/${version}";
    hash = "sha256-4AhxvUkLiej7OSj9Y19tJnVCzNlC5PF6KB5zTHN8gLA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "evohomeasync2"
  ];

  meta = with lib; {
    description = "Python client for connecting to Honeywell's TCC RESTful API";
    homepage = "https://github.com/zxdavb/evohome-async";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
