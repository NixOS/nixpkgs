{ stdenv, buildPythonPackage, fetchPypi, pytest, ply, six }:

buildPythonPackage rec {
  pname   = "lesscpy";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dcql1bgh70a9avbx9b8mq9gzdp76v8bszlik96x3rf6xxbjfmaw";
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
