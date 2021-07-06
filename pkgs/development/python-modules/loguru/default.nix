{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy27
, colorama
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.5.3";

  # python3.9 compatibility should be in the next release after 0.5.3
  disabled = isPy27 || pythonAtLeast "3.9";
  src = fetchPypi {
    inherit pname version;
    sha256 = "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319";
  };

  patches = [
    # Fixes tests with pytest>=6.2.2. Will be part of the next release after 0.5.3
    (fetchpatch {
      url = "https://github.com/Delgan/loguru/commit/31cf758ee9d22dbfa125f38153782fe20ac9dce5.patch";
      sha256 = "1lzbs8akg1s7s6xjl3samf4c4bpssqvwg5fn3mwlm4ysr7jd5y67";
    })
  ];

  checkInputs = [ pytestCheckHook colorama ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [ "tests/test_multiprocessing.py" ];
  disabledTests = [ "test_time_rotation_reopening" "test_file_buffering" ]
    ++ lib.optionals stdenv.isDarwin [ "test_rotation_and_retention" "test_rotation_and_retention_timed_file" "test_renaming" "test_await_complete_inheritance" ];

  meta = with lib; {
    homepage = "https://github.com/Delgan/loguru";
    description = "Python logging made (stupidly) simple";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum rmcgibbo ];
  };
}
