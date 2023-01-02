{ lib
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pandas
, pycryptodome
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "pyezviz";
  version = "0.2.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    rev = "refs/tags/${version}";
    hash = "sha256-XG4+UQL8M5G8Y19PNTBAL51XJRE48qorE8FapaiddYI=";
  };

  propagatedBuildInputs = [
    paho-mqtt
    pandas
    pycryptodome
    requests
    xmltodict
  ];

  # Project has no tests. test_cam_rtsp.py is more a sample for using the module
  doCheck = false;

  pythonImportsCheck = [
    "pyezviz"
  ];

  meta = with lib; {
    description = "Python interface for for Ezviz cameras";
    homepage = "https://github.com/baqs/pyEzviz/";
    changelog = "https://github.com/BaQs/pyEzviz/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
