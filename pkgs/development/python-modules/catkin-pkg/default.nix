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

buildPythonPackage (finalAttrs: {
  pname = "catkin-pkg";
  version = "1.1.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "catkin_pkg";
    tag = finalAttrs.version;
    hash = "sha256-g259RzK7CfFOUJNAXUolrAgRUoKkvlKRy3LyCmrya2E=";
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
    changelog = "https://github.com/ros-infrastructure/catkin_pkg/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Library for retrieving information about catkin packages";
    homepage = "http://wiki.ros.org/catkin_pkg";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wentasah ];
  };
})
