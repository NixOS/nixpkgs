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
  version = "0.1.9.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    rev = version;
    sha256 = "sha256-t5b2PuHC+ZY2uh+ryS+bjTS7kReZi0Rvlvkr98JFyH4=";
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

  pythonImportsCheck = [ "pyezviz" ];

  meta = with lib; {
    description = "Python interface for for Ezviz cameras";
    homepage = "https://github.com/baqs/pyEzviz/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
