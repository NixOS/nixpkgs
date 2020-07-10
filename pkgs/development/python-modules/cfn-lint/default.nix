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
, junit-xml
, networkx
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "0.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b74bb89a3d0da4a744179b07bc186b9fbc4800f929bf635bb6246e80fb91a953";
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
    junit-xml
    networkx
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata importlib-resources ];

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = "https://github.com/aws-cloudformation/cfn-python-lint";
    license = licenses.mit;
  };
}
