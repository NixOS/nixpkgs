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
  version = "0.24.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1268c9730ba869f0f630eaf5bac34795553a97385d38eb91b9f7f5c3f73c8982";
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
