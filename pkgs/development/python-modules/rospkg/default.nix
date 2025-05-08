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
  testers,
  rospkg,
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

  dependencies = [
    catkin-pkg
    distro
    distutils
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportCheck = [ "rospkg" ];

  passthru.tests.version = testers.testVersion {
    package = rospkg;
    command = "rosversion --all";
  };

  meta = {
    description = "ROS package library for Python";
    homepage = "http://wiki.ros.org/rospkg";
    changelog = "https://github.com/ros-infrastructure/rospkg/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ guelakais ];
    mainProgram = "rosversion";
  };
}
