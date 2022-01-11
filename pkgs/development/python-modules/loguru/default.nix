{ lib
, stdenv
, aiocontextvars
, buildPythonPackage
, colorama
, fetchpatch
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [
    aiocontextvars
  ];

  checkInputs = [
    pytestCheckHook
    colorama
  ];

  patches = [
    # Fixes tests with pytest>=6.2.2. Will be part of the next release after 0.5.3
    (fetchpatch {
      url = "https://github.com/Delgan/loguru/commit/31cf758ee9d22dbfa125f38153782fe20ac9dce5.patch";
      sha256 = "1lzbs8akg1s7s6xjl3samf4c4bpssqvwg5fn3mwlm4ysr7jd5y67";
    })
    # Fix tests with Python 3.9
    (fetchpatch {
      url = "https://github.com/Delgan/loguru/commit/19f518c5f1f355703ffc4ee62f0e1e397605863e.patch";
      sha256 = "0yn6smik58wdffr4svqsy2n212fwdlcfcwpgqhl9hq2zlivmsdc6";
    })
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/test_multiprocessing.py"
  ];

  disabledTests = [
    "test_time_rotation_reopening"
    "test_file_buffering"
    # Tests are failing with Python 3.10
    "test_exception_others"
    ""
  ] ++ lib.optionals stdenv.isDarwin [
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
