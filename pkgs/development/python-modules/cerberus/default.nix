{ stdenv, buildPythonPackage, fetchPypi, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12cm547hpypqd7bwcl4wr4w6varibc1dagzicg5qbp86yaa6cbih";
  };

  checkInputs = [ pytestrunner pytest ];

  checkPhase = ''
    pytest -k 'not nested_oneofs'
  '';

  meta = with stdenv.lib; {
    homepage = "http://python-cerberus.org/";
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
