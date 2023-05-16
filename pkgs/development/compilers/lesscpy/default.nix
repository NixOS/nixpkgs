<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ stdenv, lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname   = "lesscpy";
  version = "0.13.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "1bbjag13kawnjdn7q4flfrkd0a21rgn9ycfqsgfdmg658jsx1ipk";
  };

  checkInputs = with python3Packages; [ pytestCheckHook ];
  pythonImportsCheck = [ "lesscpy" ];
  propagatedBuildInputs = with python3Packages; [ ply six ];

  doCheck = false; # Really weird test failures (`nix-build-python2.css not found`)

  meta = with lib; {
    description = "Python LESS Compiler";
    homepage    = "https://github.com/lesscpy/lesscpy";
    license     = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
