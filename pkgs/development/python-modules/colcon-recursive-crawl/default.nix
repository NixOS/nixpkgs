{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-recursive-crawl";
  version = "0.2.1";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-recursive-crawl.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "idEncvPl6hFp650yV16lhApADmCK+qh1UM8XcviwUMQ=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-recursive-crawl";
    description = "An extension for colcon-core to recursively crawl for packages.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
