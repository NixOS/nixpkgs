{ lib
, stdenv
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
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Delgan";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JwhJPX58KrPdX237L43o77spycLAVFv3K9njJiRK30Y=";
  };

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
    description = "Python logging made (stupidly) simple";
    homepage = "https://github.com/Delgan/loguru";
    changelog = "https://github.com/delgan/loguru/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum rmcgibbo ];
  };
}
