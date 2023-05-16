{ lib
<<<<<<< HEAD
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
=======
, pythonAtLeast
, pythonOlder
, buildPythonPackage
, fetchPypi
, stdenv
, numpydoc
, pytestCheckHook
, lz4
, setuptools
, sphinx
, psutil
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:


buildPythonPackage rec {
  pname = "joblib";
<<<<<<< HEAD
  version = "1.3.2";
  format = "pyproject";

=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
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

=======
    hash = "sha256-4c7kp55K8iiBFk8hjUMR9gB0GX+3B+CC6AO2H20TcBg=";
  };

  nativeCheckInputs = [ sphinx numpydoc pytestCheckHook psutil ];
  propagatedBuildInputs = [ lz4 setuptools ];

  pytestFlagsArray = [ "joblib/test" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTests = [
    "test_disk_used" # test_disk_used is broken: https://github.com/joblib/joblib/issues/57
    "test_parallel_call_cached_function_defined_in_jupyter" # jupyter not available during tests
    "test_nested_parallel_warnings" # tests is flaky under load
  ] ++ lib.optionals stdenv.isDarwin [
    "test_dispatch_multiprocessing" # test_dispatch_multiprocessing is broken only on Darwin.
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/joblib/joblib/releases/tag/${version}";
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = "https://joblib.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = "https://joblib.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
