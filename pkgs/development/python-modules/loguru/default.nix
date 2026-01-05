{
  lib,
  stdenv,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  fetchpatch,
  flit-core,
  freezegun,
  pytest-mypy-plugins,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Delgan";
    repo = "loguru";
    tag = version;
    hash = "sha256-tccEzzs9TtFAZM9s43cskF9llc81Ng28LqedjLiE1m4=";
  };

  patches = [
    (fetchpatch {
      # python 3.14 compat
      url = "https://github.com/Delgan/loguru/commit/84023e2bd8339de95250470f422f096edcb8f7b7.patch";
      hash = "sha256-yXRSwI7Yjm1myL20EoU/jVuEdadmbMlCpP19YKn1MAU=";
    })
  ];

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist # massive speedup, not tested by upstream
    colorama
    freezegun
    pytest-mypy-plugins
  ];

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
