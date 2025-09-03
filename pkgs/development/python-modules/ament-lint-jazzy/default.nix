{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "ament-lint-jazzy";
  version = "0.17.3-1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros2-gbp";
    repo = "ament_lint-release";
    tag = "release/jazzy/ament_lint/${version}";
    hash = "sha256-QlbxrwGFyD8+hHrR3+VYz8nGBYgeeyIHFl/AqJLx1zM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ament_lint" ];

  meta = {
    description = "providing common API for ament linter packages";
    homepage = "https://github.com/ros2-gbp/ament_lint-release/";
    license = lib.licenses.asl20; # according to https://github.com/ros2-gbp/ament_lint-release/blob/release/jazzy/ament_lint/package.xml
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.linux;
  };
}
