{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, stdenv

# build-system
, setuptools

# propagates (optional, but unspecified)
# https://github.com/joblib/joblib#dependencies
, lz4
, psutil

# tests
, pytestCheckHook
, threadpoolctl
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "1.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kvhl5iHhd4TnlVCAttBCSJ47jilJScxExurDBPWXcrE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    lz4
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    threadpoolctl
  ];

  pytestFlagsArray = [
    "joblib/test"
  ];

  disabledTests = [
    "test_disk_used" # test_disk_used is broken: https://github.com/joblib/joblib/issues/57
    "test_parallel_call_cached_function_defined_in_jupyter" # jupyter not available during tests
    "test_nested_parallel_warnings" # tests is flaky under load
  ] ++ lib.optionals stdenv.isDarwin [
    "test_dispatch_multiprocessing" # test_dispatch_multiprocessing is broken only on Darwin.
  ];

  meta = with lib; {
    changelog = "https://github.com/joblib/joblib/releases/tag/${version}";
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = "https://joblib.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
