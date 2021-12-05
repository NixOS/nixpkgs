{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-devtools";
  version = "0.2.2";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-devtools.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "fvoBWmel4m0vdO4tkltYAe4M14NhsLRp2oKUGroKFSQ=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-devtools";
    description = "An extension for colcon-core to provide information about the plugin system.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
