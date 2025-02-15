{
  lib,
  aiohttp,
  aiozoneinfo,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "evohome-async";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    tag = version;
    hash = "sha256-CpN0QAlUqCDy6hNkuNvbjQUee40BA0UqAleR+Omm9bA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiozoneinfo
    click
    voluptuous
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "evohomeasync2" ];

  meta = with lib; {
    description = "Python client for connecting to Honeywell's TCC RESTful API";
    homepage = "https://github.com/zxdavb/evohome-async";
    changelog = "https://github.com/zxdavb/evohome-async/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "evo-client";
  };
}
