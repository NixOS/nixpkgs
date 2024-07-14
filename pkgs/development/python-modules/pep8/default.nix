{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pep8";
  version = "1.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/iSbUuIEmOWeC1xSVqpS7pn8KVsm7J6qhXdv/bn+Y3Q=";
  };

  # FAIL: test_checkers_testsuite (testsuite.test_all.Pep8TestCase)
  doCheck = false;

  meta = with lib; {
    homepage = "https://pep8.readthedocs.org/";
    description = "Python style guide checker";
    mainProgram = "pep8";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
