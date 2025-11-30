{
  lib,
  aws-sam-translator,
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
  pythonOlder,
  pyyaml,
  regex,
  sarif-om,
  setuptools,
  sympy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cfn-lint";
  version = "1.41.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-lint";
    tag = "v${version}";
    hash = "sha256-AudCeFMbCQucANLLAknCKC7gzi0vvFh9c9k7ll0a1MM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aws-sam-translator
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
