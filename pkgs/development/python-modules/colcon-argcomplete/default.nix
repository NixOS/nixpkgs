{ lib, fetchgit, buildPythonPackage, argcomplete, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-argcomplete";
  version = "0.3.3";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-argcomplete.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "3I/4ykJzcYXVatwjuDa8JyqWFbcVim7xp14S4UScRtA=";
  };

  propagatedBuildInputs = [ argcomplete colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-argcomplete";
    description = "An extension for colcon-core to provide command line completion using argcomplete.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
