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
  version = "0.16.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f52bf24c64b608bf0b2563e0e47d6fcf516abc8cfafe10cfd98ad66d94f92d6";
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
