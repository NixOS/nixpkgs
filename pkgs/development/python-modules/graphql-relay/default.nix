{ lib, buildPythonPackage, fetchPypi, graphql-core, pytestCheckHook }:

buildPythonPackage rec {
  pname = "graphql-relay";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mjmpf4abrxfyln0ykxq4xa6lp7xwgqr8631qp011hv0nfl6jgxd";
  };

  propagatedBuildInputs = [ graphql-core ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "graphql_relay" ];

  meta = with lib; {
    description = "A library to help construct a graphql-py server supporting react-relay";
    homepage = "https://github.com/graphql-python/graphql-relay-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
