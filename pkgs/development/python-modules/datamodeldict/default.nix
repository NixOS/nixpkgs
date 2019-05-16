{ stdenv
, buildPythonPackage
, fetchPypi
, xmltodict
}:

buildPythonPackage rec {
  version = "0.9.5";
  pname = "DataModelDict";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afa15c137c09e7d937e31c8956fd8092be0251c9869a6b7c1d0f81c0901bc47d";
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
