{ lib
, aws-sam-translator
, buildPythonPackage
, fetchFromGitHub
, jschema-to-python
, jsonpatch
, jsonschema
, junit-xml
, mock
, networkx
, pydot
, pytestCheckHook
, pythonOlder
, pyyaml
, regex
, sarif-om
, setuptools
, sympy
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "0.79.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-python-lint";
    rev = "refs/tags/v${version}";
    hash = "sha256-5Lb8dA8HqDdEO/Ehv5y/JlP+te46mzrTw/kNHBb9l38=";
  };

  propagatedBuildInputs = [
    aws-sam-translator
    jschema-to-python
    jsonpatch
    jsonschema
    junit-xml
    networkx
    networkx
    pyyaml
    regex
    sarif-om
    sympy
  ];

  nativeCheckInputs = [
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
    # Requires git directory
    "test_update_docs"
    # Tests depend on network access (fails in getaddrinfo)
    "test_update_resource_specs_python_2"
    "test_update_resource_specs_python_3"
    "test_sarif_formatter"
    # Some CLI tests fails
    "test_bad_config"
    "test_override_parameters"
    "test_positional_template_parameters"
    "test_template_config"
  ];

  pythonImportsCheck = [
    "cfnlint"
  ];

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = "https://github.com/aws-cloudformation/cfn-python-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-lint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
