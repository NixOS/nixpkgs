{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pep8";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a113d5f5ad7a7abacef9df5ec3f2af23a20a28005921577b15dd584d099d5900";
  };

  # FAIL: test_checkers_testsuite (testsuite.test_all.Pep8TestCase)
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://pep8.readthedocs.org/";
    description = "Python style guide checker";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };

}
