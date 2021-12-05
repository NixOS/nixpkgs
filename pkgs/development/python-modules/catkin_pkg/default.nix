{ lib, fetchgit, buildPythonPackage, docutils, python-dateutil, pyparsing, mock, flake8 }:

buildPythonPackage rec {
  pname = "catkin_pkg";
  version = "0.4.24";
  src = fetchgit {
    url = "https://github.com/ros-infrastructure/catkin_pkg.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "+M3lZbpVIsHilPxBvf5g1F+FK4XOs3paqQht99Q899k=";
  };

  propagatedBuildInputs = [ docutils python-dateutil pyparsing ];
  checkInputs = [ mock flake8 ];

  meta = with lib; {
    homepage = "https://github.com/ros-infrastructure/catkin_pkg";
    description = "Standalone Python library for the Catkin package system.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.bsd3;
  };
}
