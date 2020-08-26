{ lib, buildPythonPackage, fetchPypi, pythonOlder
, requests, zeroconf, wakeonlan
, python }:

buildPythonPackage rec {
  pname = "openwebifpy";
  version = "3.1.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zqa74i54ww9qjciiv8s58mxbs6vxq06cq5k4pxfarc0l75l4gh2";
  };

  propagatedBuildInputs = [
    requests
    zeroconf
    wakeonlan
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with lib; {
    description = "Provides a python interface to interact with a device running OpenWebIf";
    homepage = "https://openwebifpy.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

