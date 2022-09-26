{ lib, fetchgit, buildPythonPackage, colcon-core, pyyaml }:

buildPythonPackage rec {
  pname = "colcon-defaults";
  version = "0.2.5";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-defaults.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "R1gUlmMu5QDl0FX/6GzgjijRXXVE3KOi5jw6l12QlZI=";
  };

  propagatedBuildInputs = [ colcon-core pyyaml ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-defaults";
    description = "An extension for colcon-core to provide custom default values for the command line arguments from a configuration file.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
