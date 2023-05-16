<<<<<<< HEAD
{ stdenv
, lib
, allpairspy
, buildPythonPackage
, fetchPypi
, pyparsing
, pythonRelaxDepsHook
, robotframework
, setuptools
}:
=======
{ stdenv, lib, fetchPypi, buildPythonPackage, pyparsing, robotframework, allpairspy }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "RoboMachine";
  version = "0.10.0";
<<<<<<< HEAD
  format = "pyproject";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XrxHaV9U7mZ2TvySHGm6qw1AsoukppzwPq4wufIjL+k=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    pyparsing
    robotframework
    allpairspy
  ];

  pythonRemoveDeps = [
    "argparse"
  ];

  pythonRelaxDeps = [
    "pyparsing"
  ];

  pythonImportsCheck = [
    "robomachine"
  ];

  meta = with lib; {
=======
  propagatedBuildInputs = [ pyparsing robotframework allpairspy ];

  # Remove Windows .bat files
  postInstall = ''
    rm "$out/bin/"*.bat
  '';

  postPatch = ''
    substituteInPlace setup.py --replace "argparse" ""
  '';

  meta = with lib; {
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Test data generator for Robot Framework";
    homepage = "https://github.com/mkorpela/RoboMachine";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
