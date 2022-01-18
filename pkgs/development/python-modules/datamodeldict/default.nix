{ lib
, buildPythonPackage
, fetchPypi
, xmltodict
}:

buildPythonPackage rec {
  version = "0.9.8";
  pname = "DataModelDict";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65c36954efa17449c69a4d8cb11c9273593ef01428cd77a609ee134eba771550";
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
