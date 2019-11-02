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
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zwkl6hgi8wbygcc6ql6yk1if665hwk43sa9shglb2afrfm5gk3g";
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
    homepage = https://pythonhosted.org/joblib/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
