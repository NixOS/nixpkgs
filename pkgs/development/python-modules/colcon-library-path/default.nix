{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-library-path";
  version = "0.2.1";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-library-path.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "luLecQcF+saB1JlIuCd6qXVyE9EAYvNjIRLaM7ECWb8=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-library-path";
    description = "An extension for colcon-core to set an environment variable to find shared libraries at runtime.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
