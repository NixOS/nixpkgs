{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, six
, requests
, aws-sam-translator
, jsonpatch
, jsonschema
, pathlib2
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "0.19.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a723ff791fc23aced78e9cde28f18f9eeae9a24f91db2b7a20f7aa837a613b3";
  };

  propagatedBuildInputs = [
    pyyaml
    six
    requests
    aws-sam-translator
    jsonpatch
    jsonschema
    pathlib2
  ];

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = https://github.com/aws-cloudformation/cfn-python-lint;
    license = licenses.mit;
  };
}
