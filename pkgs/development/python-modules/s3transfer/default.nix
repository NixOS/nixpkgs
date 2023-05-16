{ lib
, botocore
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, stdenv
=======
, docutils
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, stdenv
, wheel
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "s3transfer";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "boto";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-cL4IOfWLRUJC5zCzmN/qRf0N/IV/MDHF/j2JDX5hlUE=";
=======
    hash = "sha256-LM1/joc6TeyLLeAHpuCTz2vgpQ3TMkHrKitfiUp5ZrY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ botocore ];

<<<<<<< HEAD
  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
=======
  buildInputs = [ docutils mock pytestCheckHook wheel ];

  disabledTestPaths = [
    # Requires network access
    "tests/integration/test_copy.py"
    "tests/integration/test_delete.py"
    "tests/integration/test_download.py"
    "tests/integration/test_processpool.py"
    "tests/integration/test_s3transfer.py"
    "tests/integration/test_upload.py"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++
  # There was a change in python 3.8 that defaults multiprocessing to spawn instead of fork on macOS
  # See https://bugs.python.org/issue33725 and https://github.com/python/cpython/pull/13603.
  # I suspect the underlying issue here is that upstream tests aren't compatible with spawn multiprocessing, and pass on linux where the default is still fork
  lib.optionals stdenv.isDarwin [ "tests/unit/test_compat.py" ];

  pythonImportsCheck = [ "s3transfer" ];

  meta = with lib; {
    description = "Library for managing Amazon S3 transfers";
    homepage = "https://github.com/boto/s3transfer";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ nickcao ];
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
