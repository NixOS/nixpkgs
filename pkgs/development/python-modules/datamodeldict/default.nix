{ stdenv
, buildPythonPackage
, fetchPypi
, xmltodict
}:

buildPythonPackage rec {
  version = "0.9.4";
  pname = "DataModelDict";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97d8e999e000cf69c48e57b1a72eb45a27d83576a38c6cd8550c230b018be7af";
  };

  propagatedBuildInputs = [ xmltodict ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/usnistgov/DataModelDict/;
    description = "Class allowing for data models equivalently represented as Python dictionaries, JSON, and XML";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
