{ lib
, buildPythonPackage
, fetchFromGitHub
, pandas
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyezviz";
  version = "0.1.8.7";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    rev = version;
    sha256 = "0k7wl9wf5i0yfdds6f9ma78ckz1p4h72z5s3qg0axzra62fvl9xg";
  };

  propagatedBuildInputs = [
    pandas
    requests
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
