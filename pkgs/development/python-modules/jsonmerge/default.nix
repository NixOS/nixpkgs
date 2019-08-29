{ lib
, buildPythonPackage
, fetchPypi
, jsonschema
}:

buildPythonPackage rec {
  pname = "jsonmerge";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03l2j1lrcwcp7af4x8agxnkib0ndybfrbhn2gi7mnk6gbxfw1aw3";
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
