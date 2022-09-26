{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-pkg-config";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-pkg-config.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "I+ttyGs9cfI6fuLsrlhmPWagU5DxamAAyGbfdfCH5d4=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-pkg-config";
    description = "An extension for colcon-core to set an environment variable to find pkg-config files.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
