{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiorussound";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noahhusby";
    repo = "aiorussound";
    rev = "refs/tags/${version}";
    hash = "sha256-wFpW+X10dGezMnzjGJsXyWMy6H8PtzhQFRCaf+A2L74=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "aiorussound" ];

  meta = with lib; {
    description = "Async python package for interfacing with Russound RIO hardware";
    homepage = "https://github.com/noahhusby/aiorussound";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
