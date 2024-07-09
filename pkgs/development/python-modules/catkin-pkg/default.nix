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
  version = "0.5.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "catkin_pkg";
    rev = version;
    hash = "sha256-DjaPpLDsLpYOZukf5tYe6ZetSNTe/DJ2lS9BUsehZ8k=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    docutils
    pyparsing
    python-dateutil
  ];

  pythonImportsCheck = [ "catkin_pkg" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "test/test_flake8.py" ];

  meta = {
    description = "Library for retrieving information about catkin packages";
    homepage = "http://wiki.ros.org/catkin_pkg";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
