{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ncurses,
  procps,
  pytest-rerunfailures,
  pytest-xdist,
  pytestCheckHook,
  tmux,
}:

buildPythonPackage (finalAttrs: {
  pname = "libtmux";
  version = "0.59.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = "libtmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RsK3nVGpgNX05tCc5kK5GFLUS5vVoe8NRKgg7Y/DzwM=";
  };

  patches = [ ./0001-fix-test_control_mode_stdout_preserves_non_ascii_out.patch ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"--doctest-docutils-modules",' ""
  '';

  build-system = [ hatchling ];

  nativeCheckInputs = [
    ncurses
    procps
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
    tmux
  ];

  enabledTestPaths = [ "tests" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test/test_retry.py" ];
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fail with: 'no server running on /tmp/tmux-1000/libtmux_test8sorutj1'.
    "test_new_session_width_height"
    # AssertionError: assert '' == '$'
    "test_capture_pane"
    # AssertionError: assert '' == '$'
    "test_capture_pane_start"
    # AssertionError: assert '' == '$'
    "test_capture_pane_end"
    # IndexError: list index out of range
    "test_new_window_with_environment"
  ];

  pythonImportsCheck = [ "libtmux" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Typed scripting library / ORM / API wrapper for tmux";
    homepage = "https://libtmux.git-pull.com/";
    changelog = "https://github.com/tmux-python/libtmux/raw/${finalAttrs.src.tag}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
  };
})
