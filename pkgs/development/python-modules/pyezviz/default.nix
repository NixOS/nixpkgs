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
  version = "0.2.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    rev = version;
    sha256 = "1zspymv8nz0gkx9m0fgls33hsw7rl0x4za87xx84ml4alcrp4r6w";
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
