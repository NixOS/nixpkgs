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
  version = "0.39.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = "libtmux";
    rev = "refs/tags/v${version}";
    hash = "sha256-JqOxJD34DL5Iku3Ov8JzwSVThqDg41PQ/v1Dz6ex4ro=";
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

  pytestFlagsArray = [ "tests" ];

  disabledTests =
    [
      # Fail with: 'no server running on /tmp/tmux-1000/libtmux_test8sorutj1'.
      "test_new_session_width_height"
      # Assertion error
      "test_capture_pane_start"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # tests/test_pane.py:113: AssertionError
      "test_capture_pane_start"
    ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/test_test.py"
  ];

  pythonImportsCheck = [ "libtmux" ];

  meta = with lib; {
    description = "Typed scripting library / ORM / API wrapper for tmux";
    homepage = "https://libtmux.git-pull.com/";
    changelog = "https://github.com/tmux-python/libtmux/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ otavio ];
  };
}
