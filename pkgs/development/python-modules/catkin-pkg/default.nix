{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docutils,
  pyparsing,
  python-dateutil,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "catkin-pkg";
  version = "1.0.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "catkin_pkg";
    rev = version;
    hash = "sha256-lHUKhE9dQLO1MbkstUEiGrHc9Rm+bY/AmgLyh7AbvFQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    pyparsing
    python-dateutil
    setuptools
  ];

  pythonImportsCheck = [ "catkin_pkg" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "test/test_flake8.py" ];

  meta = {
    changelog = "https://github.com/ros-infrastructure/catkin_pkg/blob/${version}/CHANGELOG.rst";
    description = "Library for retrieving information about catkin packages";
    homepage = "http://wiki.ros.org/catkin_pkg";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
