{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-zsh";
  version = "0.4.0";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-zsh.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "vQJdQMGQGyaLLU6ZctTcxLWFCETi1TiPLGUQPQrVAOk=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-zsh";
    description = "An extension for colcon-core to provide Z shell scripts.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
