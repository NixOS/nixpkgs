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
  version = "0.26.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "648c9fc70abc479183c63e53eebaae5a9d5236480b55e7fae033a727c21592fd";
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
    homepage = https://github.com/aws-cloudformation/cfn-python-lint;
    license = licenses.mit;
  };
}
