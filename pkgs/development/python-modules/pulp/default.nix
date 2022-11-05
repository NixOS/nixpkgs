{ lib
, fetchPypi
, buildPythonPackage
, pyparsing
, amply
}:

buildPythonPackage rec {
  pname = "PuLP";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5z7msy1jnJuM9LSt7TNLoVi+X4MTVE4Fb3lqzgoQrmM=";
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
