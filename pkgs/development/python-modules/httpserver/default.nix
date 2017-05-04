{ stdenv, fetchPypi, buildPythonPackage, docopt }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "httpserver";
  version = "1.1.0";
  buildInputs = [ docopt ];

  # Tests pull in lots of other dependencies to emulate different web
  # drivers.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q62g324dvb0hqdwwrnj41sqr4d3ly78v9nc26rz1whj4pwdmhsv";
  };
}
