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
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0630eea4f5664c463f23fbf5dcfc54a2bc6168902719fa8e19daf033022786c8";
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
