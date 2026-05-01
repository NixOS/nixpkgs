{
  lib,
  stdenv,
  buildPythonPackage,
  colorama,
  exceptiongroup,
  fetchFromGitHub,
  flit-core,
  freezegun,
  pytest-mypy-plugins,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.7.3";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Delgan";
    repo = "loguru";
    tag = version;
    hash = "sha256-tccEzzs9TtFAZM9s43cskF9llc81Ng28LqedjLiE1m4=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist # massive speedup, not tested by upstream
    colorama
    freezegun
    pytest-mypy-plugins
  ]
  ++ lib.optional (pythonOlder "3.10") exceptiongroup;

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_multiprocessing.py" ];

  disabledTests = [
    # fails on some machine configurations
    # AssertionError: assert '' != ''
    "test_file_buffering"
    # Slow test
    "test_time_rotation"
    # broken on latest mypy, fixed upstream, but does not apply cleanly
    # https://github.com/Delgan/loguru/commit/7608a014df0fa5c3322dec032345482aa5305a56
    # FIXME: remove in next update
    "typesafety"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_rotation_and_retention"
    "test_rotation_and_retention_timed_file"
    "test_renaming"
    "test_await_complete_inheritance"
  ];

  pythonImportsCheck = [ "loguru" ];

  meta = {
    description = "Python logging made (stupidly) simple";
    homepage = "https://github.com/Delgan/loguru";
    changelog = "https://github.com/delgan/loguru/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jakewaksbaum
      rmcgibbo
    ];
  };
}
