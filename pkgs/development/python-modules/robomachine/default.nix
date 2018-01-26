{ stdenv, fetchurl, buildPythonPackage, pyparsing, argparse, robotframework }:

buildPythonPackage rec {
  pname = "robomachine";
  version = "0.8.0";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/R/RoboMachine/RoboMachine-0.6.tar.gz";
    sha256 = "242cfd9be0f7591138eaeba03c9c190f894ce045e1767ab7b90eca330259fc45";
  };

  propagatedBuildInputs = [ pyparsing argparse robotframework ];

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
