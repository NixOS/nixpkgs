{ lib
, buildPythonPackage
, fetchPypi
, xmltodict
}:

buildPythonPackage rec {
  version = "0.9.7";
  pname = "DataModelDict";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1be7573cb4401aa250fd00f2e6392543f6f2498f8e02f6313595aa220e5c99e";
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
