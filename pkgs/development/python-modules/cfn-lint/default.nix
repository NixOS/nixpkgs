{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aws-sam-translator
, importlib-metadata
, importlib-resources
, jsonpatch
, jsonschema
, junit-xml
, networkx
, pathlib2
, pyyaml
, requests
, setuptools
, six
# Test inputs
, pytestCheckHook
, mock
, pydot
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "0.35.1";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo  = "cfn-python-lint";
    rev = "v${version}";
    sha256 = "1ajb0412hw9fg9m4b3xbpfbp8cixmnpjxrkaks6k749xinzsv7qk";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'importlib_resources~=1.4;python_version<"3.7" and python_version!="3.4"' 'importlib_resources;python_version<"3.7"'
  '';

  requiredPythonModules = [
    aws-sam-translator
    jsonpatch
    jsonschema
    junit-xml
    networkx
    pathlib2
    pyyaml
    requests
    setuptools
    six
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata importlib-resources ];

  pythonImportsCheck = [
    "cfnlint"
    "cfnlint.conditions"
    "cfnlint.core"
    "cfnlint.decode.node"
    "cfnlint.decode.cfn_yaml"
    "cfnlint.decode.cfn_json"
    "cfnlint.decorators.refactored"
    "cfnlint.graph"
    "cfnlint.helpers"
    "cfnlint.rules"
    "cfnlint.runner"
    "cfnlint.template"
    "cfnlint.transform"
  ];

  checkInputs = [ pytestCheckHook mock pydot ];
  preCheck = "export PATH=$out/bin:$PATH";

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = "https://github.com/aws-cloudformation/cfn-python-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-python-lint/blob/master/CHANGELOG.md";
    license = licenses.mit;
  };
}
