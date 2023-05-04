{ stdenv, lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname   = "lesscpy";
  version = "0.13.0";

  src = python3Packages.fetchPypi {
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
