{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17dd6f59e7cd52166302b2a6a3112e03fb4612eaff9bb19cd0603cf67e03c5cf";
  };

  checkPhase = ''
    py.test
  '';

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytest pytestcov mock ] ++ stdenv.lib.optional (!stdenv.isDarwin) watchdog;
}
