{ buildPythonPackage, fetchPypi, python
, plaster, PasteDeploy
, pytest, pytestcov
}:

buildPythonPackage rec {
  pname = "plaster_pastedeploy";
  version = "0.4.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a401228c7cfbe38f728249e75af7a666f91c61d642cbb8fcb78a71df69d2754";
  };

  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ plaster PasteDeploy ];
  checkInputs = [ pytest pytestcov ];
}
