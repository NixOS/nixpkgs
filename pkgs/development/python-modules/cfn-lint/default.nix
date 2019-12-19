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
  ];

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = https://github.com/aws-cloudformation/cfn-python-lint;
    license = licenses.mit;
  };
}
