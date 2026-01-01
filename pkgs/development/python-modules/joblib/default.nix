{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  pythonAtLeast,
  stdenv,

  # build-system
  setuptools,

  # propagates (optional, but unspecified)
  # https://github.com/joblib/joblib#dependencies
  lz4,
  psutil,

  # tests
  pytestCheckHook,
  threadpoolctl,
}:

buildPythonPackage rec {
  pname = "joblib";
<<<<<<< HEAD
  version = "1.5.2";
=======
  version = "1.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-P6pcOQVLLwPKVH2psvUv3mfAYkDDGFPzBq6pfxNke1U=";
=======
    hash = "sha256-9PhuNR85/j0NMqnyw9ivHuTOwoWq/LJwA92lIFV2tEQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    lz4
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    threadpoolctl
  ];

  enabledTestPaths = [ "joblib/test" ];

  disabledTests = [
    "test_disk_used" # test_disk_used is broken: https://github.com/joblib/joblib/issues/57
    "test_parallel_call_cached_function_defined_in_jupyter" # jupyter not available during tests
    "test_nested_parallel_warnings" # tests is flaky under load
    "test_memory" # tests - and the module itself - assume strictatime mount for build directory
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_dispatch_multiprocessing" # test_dispatch_multiprocessing is broken only on Darwin.
<<<<<<< HEAD
  ];

  meta = {
    changelog = "https://github.com/joblib/joblib/releases/tag/${version}";
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = "https://joblib.readthedocs.io/";
    license = lib.licenses.bsd3;
=======
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # deprecation warnings with python3.12 https://github.com/joblib/joblib/issues/1478
    "test_main_thread_renamed_no_warning"
    "test_background_thread_parallelism"
  ];

  meta = with lib; {
    changelog = "https://github.com/joblib/joblib/releases/tag/${version}";
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = "https://joblib.readthedocs.io/";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
