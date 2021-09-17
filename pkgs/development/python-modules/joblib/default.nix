{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, stdenv
, numpydoc
, pytestCheckHook
, lz4
, setuptools
, sphinx
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "1.0.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c17567692206d2f3fb9ecf5e991084254fe631665c450b443761c4186a613f7";
  };

  checkInputs = [ sphinx numpydoc pytestCheckHook ];
  propagatedBuildInputs = [ lz4 setuptools ];

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
