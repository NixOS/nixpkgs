{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, numpydoc
, pytest
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.11";
  src = fetchPypi {
    inherit pname version;
    sha256 = "7b8fd56df36d9731a83729395ccb85a3b401f62a96255deb1a77220c00ed4085";
  };

  checkInputs = [ sphinx numpydoc pytest ];

  checkPhase = ''
    py.test -k 'not test_disk_used and not test_nested_parallel_warnings' joblib/test
  '';

  meta = {
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = https://pythonhosted.org/joblib/;
    license = lib.licenses.bsd3;
  };
}
