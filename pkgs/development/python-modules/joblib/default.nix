{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, stdenv
, numpydoc
, pytest
, python-lz4
, setuptools
, sphinx
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.17.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e284edd6be6b71883a63c9b7f124738a3c16195513ad940eae7e3438de885d5";
  };

  checkInputs = [ sphinx numpydoc pytest ];
  propagatedBuildInputs = [ python-lz4 setuptools ];

  # test_disk_used is broken: https://github.com/joblib/joblib/issues/57
  # test_dispatch_multiprocessing is broken only on Darwin.
  checkPhase = ''
    py.test -k 'not test_disk_used${lib.optionalString (stdenv.isDarwin) " and not test_dispatch_multiprocessing"}' joblib/test
  '';

  meta = {
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = "https://joblib.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
