{ stdenv, pythonPackages }:

with pythonPackages;

buildPythonApplication rec {
  pname   = "lesscpy";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bbjag13kawnjdn7q4flfrkd0a21rgn9ycfqsgfdmg658jsx1ipk";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ ply six ];

  doCheck = false; # Really weird test failures (`nix-build-python2.css not found`)

  meta = with stdenv.lib; {
    description = "Python LESS Compiler";
    homepage    = https://github.com/lesscpy/lesscpy;
    license     = licenses.mit;
    maintainers = with maintainers; [ e-user ];
  };
}
