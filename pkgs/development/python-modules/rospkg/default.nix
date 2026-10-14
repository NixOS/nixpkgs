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
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "rospkg";
    tag = version;
    hash = "sha256-I6LiqL/eyM8HnSL4VZ5MfhOipV3Tu/ioCrQNziorksI=";
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
