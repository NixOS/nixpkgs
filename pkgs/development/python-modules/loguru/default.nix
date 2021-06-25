{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, colorama
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "loguru";
  version = "unstable-2021-03-19";

  disabled = isPy27;
  src = fetchFromGitHub {
    owner = "Delgan";
    repo = "loguru";
    rev = "68616485f4f0decb5fced36a16040f5e05e2842f";
    sha256 = "1gnn7hgs3c521kzlas7vs4js3ljbky6w7j61v650zrjdnas67zqd";
  };

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
