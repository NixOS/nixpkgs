{ lib, fetchgit, buildPythonPackage, colcon-core, colcon-library-path, colcon-test-result, pytest }:

buildPythonPackage rec {
  pname = "colcon-cmake";
  version = "0.2.26";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-cmake.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "H8jKNTXDd3HW8FLejgUlmhW1DQXXrZ/HOcHTrhol3ms=";
  };

  propagatedBuildInputs = [ colcon-core colcon-library-path colcon-test-result ];

  # Run only functional test
  checkInputs = [ pytest ];
  checkPhase = "pytest test/test_parse_cmake_version.py";

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-cmake";
    description = "An extension for colcon-core to support CMake projects.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
