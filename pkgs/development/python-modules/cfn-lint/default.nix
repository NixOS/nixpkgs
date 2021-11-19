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
, mock
, pydot
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "0.54.2";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-python-lint";
    rev = "v${version}";
    sha256 = "04d5zyjnrl3b6cb2fxmbpii27mnq77wqsglfxfv2a1zj2p9xby0p";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'importlib_resources~=1.4;python_version<"3.7" and python_version!="3.4"' 'importlib_resources;python_version<"3.7"'
  '';

  propagatedBuildInputs = [
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

  checkInputs = [
    mock
    pydot
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # These tests depend on the current date, for example because of issues like this.
    # This makes it possible for them to succeed on hydra and then begin to fail without
    # any code changes.
    # https://github.com/aws-cloudformation/cfn-python-lint/issues/1705
    # See also: https://github.com/NixOS/nixpkgs/issues/108076
    "TestQuickStartTemplates"
    # requires git directory
    "test_update_docs"
    # Tests depend on network access (fails in getaddrinfo)
    "test_update_resource_specs_python_2"
    "test_update_resource_specs_python_3"
  ];

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

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = "https://github.com/aws-cloudformation/cfn-python-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-python-lint/blob/master/CHANGELOG.md";
    license = licenses.mit;
  };
}
