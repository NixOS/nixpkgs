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
  version = "0.35.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ibv31jf0z69nvlbx6py2rsiz7ggdqr4rsy23s4jjfhfaa4ks0j2";
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
