{ stdenv, fetchPypi, buildPythonPackage, pyparsing }:

buildPythonPackage rec {
  pname = "PuLP";
  version = "1.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1irzpfnnm5f0qf8y9ddxi489nwixyj0q4zlvqafm621bijkxdv6g";
  };

  propagatedBuildInputs = [ pyparsing ];

  # only one test that requires an extra
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/coin-or/pulp;
    description = "PuLP is an LP modeler written in python";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
