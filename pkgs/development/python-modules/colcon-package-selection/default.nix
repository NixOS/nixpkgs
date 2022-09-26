{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-package-selection";
  version = "0.2.10";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-package-selection.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "KhvvKs5QUBthc5Zi7IqCcFAb5o1LjtOnYfN7fwj7s5k=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-package-selection";
    description = "An extension for colcon-core to select a subset of packages for processing.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
