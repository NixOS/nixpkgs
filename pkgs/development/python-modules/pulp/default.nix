{ lib
, fetchPypi
, buildPythonPackage
, pyparsing
, amply
}:

buildPythonPackage rec {
  pname = "PuLP";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27c2a87a98ea0e9a08c7c46e6df47d6d4e753ad9991fea2901892425d89c99a6";
  };

  propagatedBuildInputs = [ pyparsing amply ];

  # only one test that requires an extra
  doCheck = false;
  pythonImportsCheck = [ "pulp" ];

  meta = with lib; {
    homepage = "https://github.com/coin-or/pulp";
    description = "PuLP is an LP modeler written in python";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
