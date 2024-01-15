{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "namex";
  version = "0.0.7";
  pyproject = true;

  # Not using fetchFromGitHub because the repo does not have any tag/release.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hLplvE0ivZCePSa/L/tLlSm2CMs/mkM293awQgTO1ps=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "namex" ];

  # This packages has no tests.
  doCheck = false;

  meta = with lib; {
    description = "A simple utility to separate the implementation of your Python package and its public API surface";
    homepage = "https://github.com/fchollet/namex";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
