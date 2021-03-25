{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, stdenv
, numpydoc
, pytestCheckHook
, python-lz4
, setuptools
, sphinx
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "1.0.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "092bnvr724cfvka8267z687bf086fvm7i1hwslkyrzf1g836dn3s";
  };

  checkInputs = [ sphinx numpydoc pytestCheckHook ];
  propagatedBuildInputs = [ python-lz4 setuptools ];

  pytestFlagsArray = [ "joblib/test" ];
  disabledTests = [
    "test_disk_used" # test_disk_used is broken: https://github.com/joblib/joblib/issues/57
    "test_parallel_call_cached_function_defined_in_jupyter" # jupyter not available during tests
  ] ++ lib.optionals stdenv.isDarwin [
    "test_dispatch_multiprocessing" # test_dispatch_multiprocessing is broken only on Darwin.
  ];

  meta = with lib; {
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = "https://joblib.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
