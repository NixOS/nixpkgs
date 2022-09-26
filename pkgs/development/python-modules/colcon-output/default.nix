{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-output";
  version = "0.2.12";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-output.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "FkykRkYgem7x7ey3NFOmlnX6sAPflqpVeYSbbYkbn7I=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-output";
    description = "An extension for colcon-core to customize the output in various ways.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
