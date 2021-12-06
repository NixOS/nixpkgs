{ lib, fetchgit, buildPythonPackage, colcon-core, colcon-package-information }:

buildPythonPackage rec {
  pname = "colcon-cd";
  version = "0.1.1";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-cd.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "pL+PSgHbfLmoGsHiQnPd3y/fW8xjy1DfFJdow5sXgG4=";
  };

  propagatedBuildInputs = [ colcon-core colcon-package-information ];

  # Run only functional test
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-cd";
    description = "A shell function for colcon-core to change the current working directory.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
