{ stdenv, buildPythonPackage, fetchPypi, python
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02lj6kgaf9xpr0binxwac3gpdhljglyj9fr78s165jc7qd7mifdg";
  };

  checkPhase = ''
    py.test
  '';

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytest pytestcov mock ] ++ stdenv.lib.optional (!stdenv.isDarwin) watchdog;
}
