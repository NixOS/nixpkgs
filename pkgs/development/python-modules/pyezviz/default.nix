{ lib, buildPythonPackage, fetchFromGitHub, paho-mqtt, pandas, pycryptodome
, pythonOlder, requests, xmltodict }:

buildPythonPackage rec {
  pname = "pyezviz";
  version = "0.2.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    rev = version;
    sha256 = "sha256-a+u8zS69qLHABPSvWEzhM/gdzlLh2RJLTDJjaX4DtpI=";
  };

  propagatedBuildInputs = [ paho-mqtt pandas pycryptodome requests xmltodict ];

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
