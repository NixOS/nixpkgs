{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "evohome-async";
  version = "0.4.21";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    rev = "refs/tags/${version}";
    hash = "sha256-+tBqyg7E9wRC6oHq6Fv2vzIGtrHqZp8w/3x/xbacqWI=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    aiohttp
    click
    voluptuous
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "evohomeasync2" ];

  meta = with lib; {
    description = "Python client for connecting to Honeywell's TCC RESTful API";
    homepage = "https://github.com/zxdavb/evohome-async";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "evo-client";
  };
}
