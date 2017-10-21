{ buildPythonPackage, fetchPypi, python
, plaster, PasteDeploy
, pytest, pytestcov
}:

buildPythonPackage rec {
  pname = "plaster_pastedeploy";
  version = "0.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lrbkya5birfmg9gnfcnsa9id28klmjcqbm33rcg69pv9sfld4jv";
  };

  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ plaster PasteDeploy ];
  checkInputs = [ pytest pytestcov ];
}
