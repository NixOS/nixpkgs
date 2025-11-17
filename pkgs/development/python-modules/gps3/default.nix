{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "gps3";
  version = "unstable-2017-11-01";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wadda";
    repo = "gps3";
    rev = "91adcd7073b891b135b2a46d039ce2125cf09a09";
    hash = "sha256-sVK61l8YunKAGFTSAq/m5aUGFfnizwhqTYbdznBIKfk=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "gps3" ];

  meta = with lib; {
    description = "Python client for GPSD";
    homepage = "https://github.com/wadda/gps3";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
