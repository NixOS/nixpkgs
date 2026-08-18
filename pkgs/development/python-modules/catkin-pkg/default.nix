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
  version = "1.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "catkin_pkg";
    tag = version;
    hash = "sha256-V4iurFt1WmY2jXy0A4Qa2eKMCWmR+Hs3d9pru0/zUSM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    pyparsing
    python-dateutil
  ];

  pythonImportsCheck = [ "catkin_pkg" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "test/test_flake8.py" ];

  meta = {
    changelog = "https://github.com/ros-infrastructure/catkin_pkg/blob/${src.tag}/CHANGELOG.rst";
    description = "Library for retrieving information about catkin packages";
    homepage = "http://wiki.ros.org/catkin_pkg";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      wentasah
    ];
  };
}
