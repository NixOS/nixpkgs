{
  buildPythonPackage,
  catkin-pkg,
  distro,
  distutils,
  fetchFromGitHub,
  lib,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "rospkg";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "rospkg";
    tag = "${version}";
    hash = "sha256-6nfdY+p3P3iGuj+7Lo7ybsZ+1x104m7WzGgxr8dDDuw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    catkin-pkg
    distro
    distutils # Not mentioned in setup.py but still used by the package
    pyyaml
  ];

  setupHook = ./setup-hook.sh;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportCheck = [ "rospkg" ];

  meta = {
    description = "Standalone Python library for the ROS package system.";
    homepage = "https://github.com/ros-infrastructure/rospkg";
    changelog = "https://github.com/ros-infrastructure/rospkg/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ amronos ];
  };
}
