{
  lib,
  buildPythonPackage,
  fetchPypi,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "datamodeldict";
  version = "0.9.10";
  format = "setuptools";

  src = fetchPypi {
    pname = "DataModelDict";
    inherit version;
    hash = "sha256-1kBPRoLaunpPsHq2cKjvJ3r9j9SSY0XJHVmGcZ29BOc=";
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
