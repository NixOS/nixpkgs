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
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BmvQZ1jQpRPpg2/ZxrWnW/s/02hB9LmWvGC1R6MJ1Bw=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [
    aiocontextvars
  ];

  checkInputs = [
    pytestCheckHook
    colorama
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
