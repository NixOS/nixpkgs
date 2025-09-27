{
  lib,
  buildPythonPackage,
  colcon,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-repeat,
  pytest-rerunfailures,
  scspell,
  setuptools,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage {
  pname = "colcon-ros-domain-id-coordinator";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-ros-domain-id-coordinator";
    tag = "0.2.1";
    hash = "sha256-8DTpixa5ZGuSOpmwoeJgxLQI+17XheLxPWcJymE0GqM=";
  };
  build-system = [ setuptools ];

  dependencies = [
    colcon
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-repeat
    pytest-rerunfailures
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [
    "colcon_ros_domain_id_coordinator"
  ];

  meta = {
    description = "Extension for colcon-core to coordinate ROS_DOMAIN_ID values across multiple terminals";
    homepage = "https://github.com/colcon/colcon-ros-domain-id-coordinator";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
