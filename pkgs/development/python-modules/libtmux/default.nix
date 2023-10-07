{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, pytest-rerunfailures
, pytestCheckHook
, procps
, tmux
, ncurses
}:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.23.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-W1gBhukBooPo8uej6i8i3UxLuDeBBeSX5xU50SyjjlA=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    procps
    tmux
    ncurses
    pytest-rerunfailures
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];

  disabledTests = [
    # Fail with: 'no server running on /tmp/tmux-1000/libtmux_test8sorutj1'.
    "test_new_session_width_height"
    # Assertion error
    "test_capture_pane_start"
  ] ++ lib.optionals stdenv.isDarwin [
    # tests/test_pane.py:113: AssertionError
    "test_capture_pane_start"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/test_test.py"
    "tests/legacy_api/test_test.py"
  ];

  pythonImportsCheck = [
    "libtmux"
  ];

  meta = with lib; {
    description = "Typed scripting library / ORM / API wrapper for tmux";
    homepage = "https://libtmux.git-pull.com/";
    changelog = "https://github.com/tmux-python/libtmux/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
