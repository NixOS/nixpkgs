{ stdenv, fetchPypi, buildPythonPackage, pyparsing, robotframework, allpairspy }:

buildPythonPackage rec {
  pname = "RoboMachine";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "242cfd9be0f7591138eaeba03c9c190f894ce045e1767ab7b90eca330259fc45";
  };

  propagatedBuildInputs = [ pyparsing robotframework allpairspy ];

  # Remove Windows .bat files
  postInstall = ''
    rm "$out/bin/"*.bat
  '';

  postPatch = ''
    substituteInPlace setup.py --replace "argparse" ""
  '';

  meta = with stdenv.lib; {
    description = "Test data generator for Robot Framework";
    homepage = https://github.com/mkorpela/RoboMachine;
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
