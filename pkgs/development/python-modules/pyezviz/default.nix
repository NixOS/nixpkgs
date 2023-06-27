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
  version = "0.2.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    rev = "refs/tags/${version}";
    hash = "sha256-3NeXAqEoRJMzg/Io9WF93GFJHEjAaHNn4/lBVKc2Q3Q=";
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
