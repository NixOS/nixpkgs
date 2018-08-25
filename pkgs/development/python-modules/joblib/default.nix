{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, numpydoc
, pytest
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.12.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "e9f04885cf11704669f3a731ea6ac00bbc7dea16137aa4394ef7c272cdb9d008";
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
