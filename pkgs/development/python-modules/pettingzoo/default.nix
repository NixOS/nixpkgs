{ lib
, buildPythonPackage
, chess
, fetchFromGitHub
, gymnasium
, numpy
, pillow
, pybox2d
, pygame
, pymunk
, pytest-cov
, pytest-markdown-docs
, pytest-xdist
, pytestCheckHook
, rlcard
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "pettingzoo";
  version = "1.24.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "pettingzoo";
    rev = "refs/tags/${version}";
    hash = "sha256-TVM4MrA4W6AIWEdBIecI85ahJAAc21f27OzCxSpOoZU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    gymnasium
    numpy
  ];

  pythonImportsCheck = [
    "pettingzoo"
  ];

  nativeCheckInputs = [
    chess
    pillow
    pybox2d
    pygame
    pymunk
    pytest-cov
    pytest-markdown-docs
    pytest-xdist
    pytestCheckHook
    rlcard
    scipy
  ];

  disabledTestPaths = [
    # These tests need to write on the filesystem.
    "test/pickle_test.py"

    # These tests need all the environments to work.
    "test/all_parameter_combs_test.py"
    "test/unwrapped_test.py"
    "test/wrapper_test.py"
  ];

  meta = with lib; {
    description = "Gymnasium for multi-agent reinforcement learning.";
    homepage = "https://github.com/Farama-Foundation/PettingZoo";
    license = licenses.mit;
    maintainers = with maintainers; [ alexkireeff ];
  };
}
