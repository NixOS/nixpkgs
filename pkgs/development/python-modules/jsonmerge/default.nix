{ lib
, buildPythonPackage
, fetchPypi
, jsonschema
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonmerge";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a86bfc44f32f6a28b749743df8960a4ce1930666b3b73882513825f845cb9558";
  };

  propagatedBuildInputs = [ jsonschema ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # Fails with "Unresolvable JSON pointer"
    "test_local_reference_in_meta"
  ];

  meta = with lib; {
    description = "Merge a series of JSON documents";
    homepage = "https://github.com/avian2/jsonmerge";
    changelog = "https://github.com/avian2/jsonmerge/blob/jsonmerge-${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
