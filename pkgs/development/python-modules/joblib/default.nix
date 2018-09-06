{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, numpydoc
, pytest
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.12.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "333b9bf16ff015d6b56bf80b9831afdd243443cb84c7ff7b6e342f117e354c42";
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
