{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "evohome-async";
  version = "0.3.15";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = pname;
    rev = version;
    hash = "sha256-/dZRlcTcea26FEpw/XDItKh4ncr/eEFQcdfIE2KIMo8=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "evohomeasync2" ];

  meta = with lib; {
    description = "Python client for connecting to Honeywell's TCC RESTful API";
    homepage = "https://github.com/zxdavb/evohome-async";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
