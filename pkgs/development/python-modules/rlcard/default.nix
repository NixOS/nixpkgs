{ lib
, buildPythonPackage
, fetchFromGitHub
, gitdb
, gitpython
, matplotlib
, numpy
, pip
, setuptools
, termcolor
, torch
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "rlcard";
  version = "7fc56edebe9a2e39c94f872edd8dbe325c61b806";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "datamllab";
    repo = "rlcard";
    rev = version;
    hash = "sha256-kQ1gWP7l/0vLsi7YcLJSskNEGNH8HaOBm4yJ7GSkSE4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    termcolor
  ];

  pythonImportsCheck = [
    "rlcard"
  ];

  nativeCheckInputs = [
    gitdb
    gitpython
    matplotlib
    pip
    torch
    unittestCheckHook
  ];

  meta = with lib; {
    description = "A Toolkit for Reinforcement Learning in Card Games.";
    homepage = "https://github.com/datamllab/rlcard";
    license = licenses.mit;
    maintainers = with maintainers; [ alexkireeff ];
  };
}
