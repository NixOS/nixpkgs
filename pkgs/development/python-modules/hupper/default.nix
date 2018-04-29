{ stdenv, buildPythonPackage, fetchPypi, python
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e18037fa43fb4af7c00bd262ca6f5d7bcd22debd5d71e43b0fb1437f56e78035";
  };

  checkPhase = ''
    py.test
  '';

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytest pytestcov mock ] ++ stdenv.lib.optional (!stdenv.isDarwin) watchdog;
}
