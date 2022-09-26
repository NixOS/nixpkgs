{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-package-information";
  version = "0.3.3";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-package-information.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "f3MHXS2B1gM6CUpC6C6uPoJx+FPWznClJ4HoTM1ch1k=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-package-information";
    description = "An extension for colcon-core to provide information about the packages.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
