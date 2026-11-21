{
  lib,
  boto3,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  jschema-to-python,
  jsonpatch,
  junit-xml,
  mock,
  networkx,
  pydot,
  pytestCheckHook,
  pyyaml,
  regex,
  sarif-om,
  setuptools,
  sympy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "1.57.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-lint";
    tag = "v${version}";
    hash = "sha256-rk7CZOg7i/hgMZFk2hoMrTc6JR5dDRZyR5pMk7wcP1A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonpatch
    networkx
    pyyaml
    regex
    sympy
    typing-extensions
  ];

  optional-dependencies = {
    graph = [ pydot ];
    junit = [ junit-xml ];
    sarif = [
      jschema-to-python
      sarif-om
    ];
    full = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "full" ]);
  };

  nativeCheckInputs = [
    boto3
    defusedxml
    mock
    pytestCheckHook
  ]
  ++ optional-dependencies.full;

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # Requires git directory
    "test_update_docs"
    # Requires network access
    "test_update_force"
  ];

  disabledTestPaths = [
    # Requires full schemas downloaded with `cfn-lint -u`
    "test/integration"
  ];

  pythonImportsCheck = [ "cfnlint" ];

  meta = {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    mainProgram = "cfn-lint";
    homepage = "https://github.com/aws-cloudformation/cfn-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-lint/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit0;
    maintainers = [ ];
  };
}
