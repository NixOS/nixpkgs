{ buildPythonPackage, fetchPypi
, plaster, PasteDeploy
, pytest, pytestcov
}:

buildPythonPackage rec {
  pname = "plaster_pastedeploy";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c231130cb86ae414084008fe1d1797db7e61dc5eaafb5e755de21387c27c6fae";
  };

  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ plaster PasteDeploy ];
  checkInputs = [ pytest pytestcov ];
}
