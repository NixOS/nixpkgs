{ lib, fetchgit, buildPythonPackage, pytest, colcon-core, colcon-recursive-crawl, catkin_pkg, colcon-pkg-config, colcon-cmake, colcon-python-setup-py }:

buildPythonPackage rec {
  pname = "colcon-ros";
  version = "0.3.21";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-ros.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "BnlXCO4yTtmyMfvIK8pj/M2NAP1CpGbk77PFsNlwlf0=";
  };

  propagatedBuildInputs = [ colcon-core colcon-recursive-crawl catkin_pkg colcon-pkg-config colcon-cmake colcon-python-setup-py ];

  # Run only functional test
  checkInputs = [ pytest ];
  checkPhase = "pytest test/test_dependency_metadata.py";

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-ros";
    description = "An extension for colcon-core to support ROS packages.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
