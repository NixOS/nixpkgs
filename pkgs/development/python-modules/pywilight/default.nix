{ lib
, buildPythonPackage
, fetchPypi
, ifaddr
, requests
}:

buildPythonPackage rec {
  pname = "pywilight";
  version = "0.0.70";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PLahGx75oEp4NIZB9PVRdA3cLBxhQsHTsnquy7WSEC8=";
  };

  propagatedBuildInputs = [
    ifaddr
    requests
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "pywilight" ];

  meta = with lib; {
    description = "Python API for WiLight device";
    homepage = "https://github.com/leofig-rj/pywilight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
