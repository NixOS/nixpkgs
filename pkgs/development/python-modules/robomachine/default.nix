{ stdenv, lib, fetchPypi, buildPythonPackage, pyparsing, robotframework, allpairspy }:

buildPythonPackage rec {
  pname = "RoboMachine";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4251d405759a38f1e665acc245dcbcdec319376718169a73c57560183370fe0e";
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
