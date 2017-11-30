{ stdenv, fetchurl, buildPythonPackage, pyparsing, argparse, robotframework }:

buildPythonPackage rec {
  pname = "robomachine";
  version = "0.6";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/R/RoboMachine/RoboMachine-0.6.tar.gz";
    sha256 = "6c9a9bae7bffa272b2a09b05df06c29a3a776542c70cae8041a8975a061d2e54";
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
