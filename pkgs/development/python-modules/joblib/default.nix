{ lib
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
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61e49189c84b3c5d99a969d314853f4d1d263316cc694bec17548ebaa9c47b6e";
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
