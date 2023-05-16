{ lib
, stdenv
<<<<<<< HEAD
, buildPythonPackage
, colorama
, fetchFromGitHub
, freezegun
=======
, aiocontextvars
, buildPythonPackage
, colorama
, fetchpatch
, fetchFromGitHub
, freezegun
, mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "loguru";
<<<<<<< HEAD
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  # No release since Jan 2022, only master is compatible with Python 3.11
  # https://github.com/Delgan/loguru/issues/740
  version = "unstable-2023-01-20";
  format = "setuptools";

  disabled = pythonOlder "3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Delgan";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-JwhJPX58KrPdX237L43o77spycLAVFv3K9njJiRK30Y=";
  };

=======
    rev = "07f94f3c8373733119f85aa8b9ca05ace3325a4b";
    hash = "sha256-lMGyQbBX3z6186ojs/iew7JMrG91ivPA679T9r+7xYw=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [
    aiocontextvars
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
    colorama
    freezegun
<<<<<<< HEAD
  ];

  disabledTestPaths = [
    "tests/test_type_hinting.py" # avoid dependency on mypy
  ] ++ lib.optionals stdenv.isDarwin [
    "tests/test_multiprocessing.py"
  ];

  disabledTests = [
    # fails on some machine configurations
    # AssertionError: assert '' != ''
    "test_file_buffering"
  ] ++ lib.optionals stdenv.isDarwin [
=======
    mypy
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/test_multiprocessing.py"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_rotation_and_retention"
    "test_rotation_and_retention_timed_file"
    "test_renaming"
    "test_await_complete_inheritance"
  ];

  pythonImportsCheck = [
    "loguru"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Python logging made (stupidly) simple";
    homepage = "https://github.com/Delgan/loguru";
    changelog = "https://github.com/delgan/loguru/releases/tag/${version}";
=======
    homepage = "https://github.com/Delgan/loguru";
    description = "Python logging made (stupidly) simple";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum rmcgibbo ];
  };
}
