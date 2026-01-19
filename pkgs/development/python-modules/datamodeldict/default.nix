{
  lib,
  buildPythonPackage,
  fetchPypi,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "datamodeldict";
  version = "0.9.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "DataModelDict";
    inherit version;
    hash = "sha256-DadBRsc8qEu9PWgMNllGS2ESKL7kgBLDhg4yDr87WRk=";
  };

  propagatedBuildInputs = [ xmltodict ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "DataModelDict" ];

  meta = {
    description = "Class allowing for data models equivalently represented as Python dictionaries, JSON, and XML";
    homepage = "https://github.com/usnistgov/DataModelDict/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
