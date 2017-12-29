{ buildPythonPackage, fetchPypi, python
, pytest, pytestcov
}:

buildPythonPackage rec {
  pname = "plaster";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8351c7c7efdf33084c1de88dd0f422cbe7342534537b553c49b857b12d98c8c3";
  };

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest pytestcov ];
}
