{ stdenv
, buildPythonPackage
, fetchPypi
, xmltodict
}:

buildPythonPackage rec {
  version = "0.9.6";
  pname = "DataModelDict";

  src = fetchPypi {
    inherit pname version;
    sha256 = "857d4bf33f0b26ca718bd821fda7502dd6fb15aa09201b1fbdfaf4dfc85b8f6c";
  };

  propagatedBuildInputs = [ xmltodict ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/usnistgov/DataModelDict/";
    description = "Class allowing for data models equivalently represented as Python dictionaries, JSON, and XML";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
