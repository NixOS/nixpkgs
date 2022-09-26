{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-bash";
  version = "0.4.2";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-bash.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "2VLwcEPuuLYd9WwdrPV7qQYOjTV6hBHdS4PRj/G/CYA=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-bash";
    description = "An extension for colcon-core to provide Bash scripts.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
