{ lib
, buildPythonPackage
, fetchPypi
, jsonschema
}:

buildPythonPackage rec {
  pname = "jsonmerge";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2004a421890311176136fb911c339c4bab45984808814feaed6a328c6e211ba2";
  };

  propagatedBuildInputs = [ jsonschema ];

  meta = with lib; {
    description = "Merge a series of JSON documents";
    homepage = https://github.com/avian2/jsonmerge;
    changelog = "https://github.com/avian2/jsonmerge/blob/jsonmerge-${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
