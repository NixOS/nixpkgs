{ lib, fetchgit, buildPythonPackage, colcon-core, notify2 }:

buildPythonPackage rec {
  pname = "colcon-notification";
  version = "0.2.13";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-notification.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "jCweisrItZnPmLiyns5F9n1WouzwabYwsuHs4RvJkhU=";
  };

  propagatedBuildInputs = [ colcon-core notify2 ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-notification";
    description = "An extension for colcon-core to provide status notifications.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
