{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ncurses,
  procps,
  pytest-rerunfailures,
  pytestCheckHook,
  tmux,
}:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.46.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = "libtmux";
    tag = "v${version}";
    hash = "sha256-M3su+bDFuvmNEDVK+poWfxwbpsw/0L1/R6Z4CL0mvZ4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"--doctest-docutils-modules",' ""
  '';

  build-system = [ hatchling ];

  nativeCheckInputs = [
    procps
    tmux
    ncurses
    pytest-rerunfailures
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # Fail with: 'no server running on /tmp/tmux-1000/libtmux_test8sorutj1'.
    "test_new_session_width_height"
    # Assertion error
    "test_capture_pane_start"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # tests/test_pane.py:113: AssertionError
    "test_capture_pane_start"
    # assert (1740973920.500444 - 1740973919.015309) <= 1.1
    "test_retry_three_times"
    "test_function_times_out_no_raise"
    # assert False
    "test_retry_three_times_no_raise_assert"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test/test_retry.py" ];

  pythonImportsCheck = [ "libtmux" ];

  meta = {
    description = "Typed scripting library / ORM / API wrapper for tmux";
    homepage = "https://libtmux.git-pull.com/";
    changelog = "https://github.com/tmux-python/libtmux/raw/v${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
