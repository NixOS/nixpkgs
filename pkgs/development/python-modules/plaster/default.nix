{ buildPythonPackage, fetchPypi, python
, pytest, pytestcov
}:

buildPythonPackage rec {
  pname = "plaster";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z48pis4qyhyqj3ia82r04diaa153dw66wrpbly06hdzvhw8j0ia";
  };

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest pytestcov ];
}
