{
  lib,
  aws-sam-translator,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  jschema-to-python,
  jsonpatch,
<<<<<<< HEAD
=======
  jsonschema,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  typing-extensions,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "cfn-lint";
<<<<<<< HEAD
  version = "1.41.0";
=======
  version = "1.38.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-lint";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AudCeFMbCQucANLLAknCKC7gzi0vvFh9c9k7ll0a1MM=";
=======
    hash = "sha256-n3NHmbo3qRhP7oqUOokw8oGnNXo4rhRhuAgL66hvfog=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    aws-sam-translator
<<<<<<< HEAD
    jsonpatch
    networkx
    pyyaml
    regex
    sympy
    typing-extensions
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  optional-dependencies = {
    graph = [ pydot ];
    junit = [ junit-xml ];
    sarif = [
      jschema-to-python
      sarif-om
    ];
<<<<<<< HEAD
    full = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "full" ]);
=======
    full = [
      jschema-to-python
      junit-xml
      pydot
      sarif-om
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeCheckInputs = [
    defusedxml
    mock
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ optional-dependencies.full;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

<<<<<<< HEAD
=======
  disabledTestPaths = [
    # tests fail starting on 2025-10-01
    # related: https://github.com/aws-cloudformation/cfn-lint/issues/4125
    "test/integration/test_quickstart_templates.py"
    "test/integration/test_quickstart_templates_non_strict.py"
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  disabledTests = [
    # Requires git directory
    "test_update_docs"
  ];

  pythonImportsCheck = [ "cfnlint" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    mainProgram = "cfn-lint";
    homepage = "https://github.com/aws-cloudformation/cfn-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-lint/blob/${src.tag}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
