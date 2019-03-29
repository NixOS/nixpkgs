{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb3778398658a011c96e620adcd73175f306f880a6d86b2ebb6d2a15a74b6b9b";
  };

  checkPhase = ''
    py.test
  '';

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytest pytestcov mock ] ++ stdenv.lib.optional (!stdenv.isDarwin) watchdog;
}
