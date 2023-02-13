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
  version = "0.21.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nZPVS3jNz2e2LTlWiSz1fN7MzqJs/CqtAt6UVZaPPTY=";
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
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "test_test.py"
  ];

  pythonImportsCheck = [ "libtmux" ];

  meta = with lib; {
    description = "Typed scripting library / ORM / API wrapper for tmux";
    homepage = "https://libtmux.git-pull.com/";
    changelog = "https://github.com/tmux-python/libtmux/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
