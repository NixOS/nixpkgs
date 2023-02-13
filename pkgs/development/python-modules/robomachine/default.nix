{ stdenv, lib, fetchPypi, buildPythonPackage, pyparsing, robotframework, allpairspy }:

buildPythonPackage rec {
  pname = "RoboMachine";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XrxHaV9U7mZ2TvySHGm6qw1AsoukppzwPq4wufIjL+k=";
  };

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
    description = "Test data generator for Robot Framework";
    homepage = "https://github.com/mkorpela/RoboMachine";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
