{ lib, buildPythonPackage, fetchPypi, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1b21b3954b2498d9a79edf16b3170a3ac1021df88d197dc2ce5928ba519237c";
  };

  checkInputs = [ pytestrunner pytest ];

  checkPhase = ''
    pytest -k 'not nested_oneofs'
  '';

  meta = with lib; {
    homepage = "http://python-cerberus.org/";
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
