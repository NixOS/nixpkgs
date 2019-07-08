{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe8febd68cec7fbed174fcbb0b42c427f96c8a7471c1cd4999fc698dd8dc6c34";
  };

  checkPhase = ''
    py.test
  '';

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytest pytestcov mock ] ++ stdenv.lib.optional (!stdenv.isDarwin) watchdog;
}
