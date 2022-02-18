{ lib
, buildPythonPackage
, fetchPypi
, xmltodict
}:

buildPythonPackage rec {
  version = "0.9.9";
  pname = "DataModelDict";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DadBRsc8qEu9PWgMNllGS2ESKL7kgBLDhg4yDr87WRk=";
  };

  propagatedBuildInputs = [ xmltodict ];

  # no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/usnistgov/DataModelDict/";
    description = "Class allowing for data models equivalently represented as Python dictionaries, JSON, and XML";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
