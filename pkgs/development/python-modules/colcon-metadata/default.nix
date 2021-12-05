{ lib, fetchgit, buildPythonPackage, colcon-core, pyyaml }:

buildPythonPackage rec {
  pname = "colcon-metadata";
  version = "0.2.5";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-metadata.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "pNbE+KVkVln9rLoJH7jH+s6f8y8a/v0YRIeIRxzsEI8=";
  };

  propagatedBuildInputs = [ colcon-core pyyaml ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-metadata";
    description = "An extension for colcon-core to fetch and manage package metadata from repositories.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
