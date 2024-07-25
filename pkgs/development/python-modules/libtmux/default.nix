{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  ncurses,
  poetry-core,
  procps,
  pytest-rerunfailures,
  pytestCheckHook,
  tmux,
}:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.37.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = "libtmux";
    rev = "refs/tags/v${version}";
    hash = "sha256-I0E6zkfQ6mx2svCaXEgKPhrrog3iLgXZ4E3CMMxPkIA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"--doctest-docutils-modules",' ""
  '';

  build-system = [ poetry-core ];

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
    ++ lib.optionals stdenv.isDarwin [
      # tests/test_pane.py:113: AssertionError
      "test_capture_pane_start"
    ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
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
