{
  lib,
  buildPythonPackage,
  catkin-pkg,
  distro,
  distutils,
  fetchFromGitHub,
  pytestCheckHook,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rospkg";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "rospkg";
    tag = version;
    hash = "sha256-6nfdY+p3P3iGuj+7Lo7ybsZ+1x104m7WzGgxr8dDDuw=";
  };

  build-system = [ setuptools ];

  setupHook = ./setup-hook.sh;

  dependencies = [
    catkin-pkg
    distro
    distutils
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rospkg" ];

  meta = {
    description = "ROS package library for Python";
    homepage = "http://wiki.ros.org/rospkg";
    changelog = "https://github.com/ros-infrastructure/rospkg/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
