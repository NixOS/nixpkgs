{ lib
, fetchPypi
, buildPythonPackage
, pyparsing
, amply
}:

buildPythonPackage rec {
  pname = "PuLP";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b4f7e1e954453e1b233720be23aea2f10ff068a835ac10c090a93d8e2eb2e8d";
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
