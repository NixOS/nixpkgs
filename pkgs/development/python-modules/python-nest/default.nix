{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  requests,
  six,
  sseclient-py,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-nest";
  version = "4.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-01hoZbDssbJ10NA72gOtlzjZMGjsUBUoVDVM35uAOLU=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
    six
    sseclient-py
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nest" ];

  meta = {
    description = "Python API and command line tool for talking to the Nest™ Thermostat";
    homepage = "https://github.com/jkoelker/python-nest";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
