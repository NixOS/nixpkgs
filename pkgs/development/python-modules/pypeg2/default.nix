{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "2.15.2";
  format = "setuptools";
  pname = "pypeg2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v8ziaam2r637v94ra4dbjw6jzxz99gs5x4i585kgag1v204yb9b";
  };

  checkPhase = ''
    # The tests assume that test_xmlast does not run before test_pyPEG2.
    python -m unittest pypeg2.test.test_pyPEG2 pypeg2.test.test_xmlast
  '';

  #https://bitbucket.org/fdik/pypeg/issues/36/test-failures-on-py35
  doCheck = !isPy3k;

  meta = with lib; {
    description = "PEG parser interpreter in Python";
    homepage = "http://fdik.org/pyPEG";
    license = licenses.gpl2;
  };

}
