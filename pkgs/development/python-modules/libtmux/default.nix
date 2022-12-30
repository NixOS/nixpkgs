{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, pytestCheckHook
, procps
, tmux
}:

buildPythonPackage rec {
  pname = "libtmux";
  version = "0.18.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmux-python";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-OhNyJcnxjbyP/Kpt70qLv3ZtZvXXVTWEMcjv/pa50/4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    procps
    tmux

    pytestCheckHook
  ];

  pytestFlagsArray = lib.optionals stdenv.isDarwin [ "--ignore=tests/test_test.py" ];

  pythonImportsCheck = [ "libtmux" ];

  meta = with lib; {
    description = "Typed scripting library / ORM / API wrapper for tmux";
    homepage = "https://libtmux.git-pull.com/";
    changelog = "https://github.com/tmux-python/libtmux/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
