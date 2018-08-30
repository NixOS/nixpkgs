{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, numpydoc
, pytest
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.12.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "68e6128e4734196616a39e2d48830ec7d61551c7f5748849e4c91478d2444524";
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
