{
  lib,
  stdenv,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  pythonOlder,
  pytest-xdist
}:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Delgan";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1xcPAOOhjFmWSxmPj6NICRur3ITOuQRNNKPJlfp89Jw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist # massive speedup, not tested by upstream
    colorama
    freezegun
  ];

  disabledTestPaths = [
    "tests/test_type_hinting.py" # avoid dependency on mypy
  ] ++ lib.optionals stdenv.isDarwin [ "tests/test_multiprocessing.py" ];

  disabledTests =
    [
      # fails on some machine configurations
      # AssertionError: assert '' != ''
      "test_file_buffering"
      # Slow test
      "test_time_rotation"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "test_rotation_and_retention"
      "test_rotation_and_retention_timed_file"
      "test_renaming"
      "test_await_complete_inheritance"
    ];

  pythonImportsCheck = [ "loguru" ];

  meta = with lib; {
    description = "Python logging made (stupidly) simple";
    homepage = "https://github.com/Delgan/loguru";
    changelog = "https://github.com/delgan/loguru/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      jakewaksbaum
      rmcgibbo
    ];
  };
}
