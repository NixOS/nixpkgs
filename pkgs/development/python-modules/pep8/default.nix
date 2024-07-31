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
    sha256 = "fe249b52e20498e59e0b5c5256aa52ee99fc295b26ec9eaa85776ffdb9fe6374";
  };

  # FAIL: test_checkers_testsuite (testsuite.test_all.Pep8TestCase)
  doCheck = false;

  meta = with lib; {
    homepage = "https://pep8.readthedocs.org/";
    description = "Python style guide checker";
    mainProgram = "pep8";
    license = licenses.mit;
    maintainers = [ ];
  };
}
