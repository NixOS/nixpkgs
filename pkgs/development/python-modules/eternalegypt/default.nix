{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eternalegypt";
  version = "0.0.15";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-CKiv5gVHaEyO9P5x2FKgpSIm2pUiFptaEQVPZHALASk=";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "eternalegypt" ];

  meta = with lib; {
    description = "Python API for Netgear LTE modems";
    homepage = "https://github.com/amelchio/eternalegypt";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
