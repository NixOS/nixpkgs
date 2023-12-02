{ lib, buildPythonPackage, fetchPypi, pythonOlder
, requests, zeroconf, wakeonlan
, python }:

buildPythonPackage rec {
  pname = "openwebifpy";
  version = "4.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4KYLjRD2n98t/MVan4ox19Yhz0xkSEMUKYdWqcwmBs4=";
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

