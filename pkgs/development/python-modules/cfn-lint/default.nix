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
  version = "0.24.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5aa1540ee9a7efc23ebe54a22f1a505766a4bb44f64a0f4fe79574a156a9b43e";
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
