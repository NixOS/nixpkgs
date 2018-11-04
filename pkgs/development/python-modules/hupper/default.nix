{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9d9ab2457fdd01ee20278d3d7dfc91c49cae329863f47571a4a2e78d90fa738";
  };

  checkPhase = ''
    py.test
  '';

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytest pytestcov mock ] ++ stdenv.lib.optional (!stdenv.isDarwin) watchdog;
}
