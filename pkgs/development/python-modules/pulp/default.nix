{ stdenv, fetchPypi, buildPythonPackage, pyparsing }:

buildPythonPackage rec {
  pname = "PuLP";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb0b0e8073aa82f3459c4241b9625e0ccd26c0838ad8253c6bc67e041901b765";
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
