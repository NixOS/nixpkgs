{
  stdenv,
  lib,
  allpairspy,
  buildPythonPackage,
  fetchPypi,
  pyparsing,
  robotframework,
  setuptools,
}:

buildPythonPackage rec {
  pname = "robomachine";
  version = "0.10.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "RoboMachine";
    inherit version;
    hash = "sha256-XrxHaV9U7mZ2TvySHGm6qw1AsoukppzwPq4wufIjL+k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyparsing
    robotframework
    allpairspy
  ];

  pythonRemoveDeps = [ "argparse" ];

  pythonRelaxDeps = [ "pyparsing" ];

  pythonImportsCheck = [ "robomachine" ];

  meta = with lib; {
    description = "Test data generator for Robot Framework";
    homepage = "https://github.com/mkorpela/RoboMachine";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
