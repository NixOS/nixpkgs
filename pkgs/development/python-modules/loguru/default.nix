{ lib
, stdenv
, aiocontextvars
, buildPythonPackage
, colorama
, fetchpatch
, fetchFromGitHub
, freezegun
, mypy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "loguru";
  # No release since Jan 2022, only master is compatible with Python 3.11
  # https://github.com/Delgan/loguru/issues/740
  version = "unstable-2023-01-20";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Delgan";
    repo = pname;
    rev = "07f94f3c8373733119f85aa8b9ca05ace3325a4b";
    hash = "sha256-lMGyQbBX3z6186ojs/iew7JMrG91ivPA679T9r+7xYw=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [
    aiocontextvars
  ];

  nativeCheckInputs = [
    pytestCheckHook
    colorama
    freezegun
    mypy
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/test_multiprocessing.py"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_rotation_and_retention"
    "test_rotation_and_retention_timed_file"
    "test_renaming"
    "test_await_complete_inheritance"
  ];

  pythonImportsCheck = [
    "loguru"
  ];

  meta = with lib; {
    homepage = "https://github.com/Delgan/loguru";
    description = "Python logging made (stupidly) simple";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum rmcgibbo ];
  };
}
