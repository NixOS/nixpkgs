{
  lib,
  aws-sam-translator,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  jschema-to-python,
  jsonpatch,
  jsonschema,
  junit-xml,
  mock,
  networkx,
  pydot,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  regex,
  sarif-om,
  setuptools,
  sympy,
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "1.38.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-lint";
    tag = "v${version}";
    hash = "sha256-n3NHmbo3qRhP7oqUOokw8oGnNXo4rhRhuAgL66hvfog=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  optional-dependencies = {
    graph = [ pydot ];
    junit = [ junit-xml ];
    sarif = [
      jschema-to-python
      sarif-om
    ];
    full = [
      jschema-to-python
      junit-xml
      pydot
      sarif-om
    ];
  };

  nativeCheckInputs = [
    defusedxml
    mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # Requires git directory
    "test_update_docs"
  ];

  pythonImportsCheck = [ "cfnlint" ];

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    mainProgram = "cfn-lint";
    homepage = "https://github.com/aws-cloudformation/cfn-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-lint/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
