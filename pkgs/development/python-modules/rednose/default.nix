{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, nose, six, colorama, termstyle }:

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

  # Do not test on Python 2 because the tests suite gets stuck
  # https://github.com/NixOS/nixpkgs/issues/60786
  # Also macOS tests are broken on python38
  doCheck = !(isPy27 || (stdenv.isDarwin && pythonAtLeast "3.8"));

  nativeCheckInputs = [ six ];
  propagatedBuildInputs = [ nose colorama termstyle ];

  meta = with lib; {
    description = "A python nose plugin adding color to console results";
    homepage = "https://github.com/JBKahn/rednose";
    license = licenses.mit;
  };
}
