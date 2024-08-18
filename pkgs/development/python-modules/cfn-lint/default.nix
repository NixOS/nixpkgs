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
  version = "1.10.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-lint";
    rev = "refs/tags/v${version}";
    hash = "sha256-so97s1PwAlLAnS86Y4yG30LuGxNGmw4Z+K2tk1WifdQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aws-sam-translator
    jsonpatch
    networkx
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
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
    # Assertion error
    "test_build_graph"
  ];

  pythonImportsCheck = [ "cfnlint" ];

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = "https://github.com/aws-cloudformation/cfn-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-lint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "cfn-lint";
  };
}
