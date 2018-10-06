{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "899a1da85b71b62d903b5732703cad7454425b4ba9a6453930ad9168ec08ae0e";
  };

  checkPhase = ''
    py.test
  '';

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytest pytestcov mock ] ++ stdenv.lib.optional (!stdenv.isDarwin) watchdog;
}
