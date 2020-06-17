{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyyaml
, six
, requests
, aws-sam-translator
, importlib-metadata
, importlib-resources
, jsonpatch
, jsonschema
, pathlib2
, setuptools
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "0.26.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "384c37d239579c7b9f61a3aaadb92ebe81f37cd6ee6a161485401179af6c7a44";
  };

  propagatedBuildInputs = [
    pyyaml
    six
    requests
    aws-sam-translator
    jsonpatch
    jsonschema
    pathlib2
    setuptools
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata importlib-resources ];

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = "https://github.com/aws-cloudformation/cfn-python-lint";
    license = licenses.mit;
  };
}
