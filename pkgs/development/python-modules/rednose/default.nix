{ lib, buildPythonPackage, fetchPypi, nose, six, colorama, termstyle }:

buildPythonPackage rec {
  pname = "rednose";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6da77917788be277b70259edc0bb92fc6f28fe268b765b4ea88206cc3543a3e1";
  };

  prePatch = ''
    substituteInPlace setup.py --replace "six==1.10.0" "six>=1.10.0"
  '';

  checkInputs = [ six ];
  propagatedBuildInputs = [ nose colorama termstyle ];

  meta = with lib; {
    description = "A python nose plugin adding color to console results";
    homepage = https://github.com/JBKahn/rednose;
    license = licenses.mit;
  };
}
