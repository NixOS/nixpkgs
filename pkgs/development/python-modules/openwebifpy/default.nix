{ lib, buildPythonPackage, fetchPypi, pythonOlder
, requests, zeroconf, wakeonlan
, python }:

buildPythonPackage rec {
  pname = "openwebifpy";
  version = "3.2.7";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n9vi6b0y8b41fd7m9p361y3qb5m3b9p9d8g4fasqi7yy4mw2hns";
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

