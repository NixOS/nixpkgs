{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  packaging,
  pythonOlder,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "adjusttext";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Phlya";
    repo = "adjusttext";
    rev = "refs/tags/v${version}";
    hash = "sha256-WMWT2os3ADQOc1ogoCFKBEWnb6/CxgtiWmY45bYomks=";
  };

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    matplotlib
    numpy
    scipy
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "adjustText" ];

  meta = with lib; {
    description = "Iteratively adjust text position in matplotlib plots to minimize overlaps";
    homepage = "https://github.com/Phlya/adjustText";
    changelog = "https://github.com/Phlya/adjustText/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
