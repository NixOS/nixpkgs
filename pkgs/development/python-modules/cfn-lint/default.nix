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
  version = "1.18.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-lint";
    rev = "refs/tags/v${version}";
    hash = "sha256-e06ytX1scIsmw/SezIVVnGn0day1l6kQ/wb05E8O7h0=";
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
    mainProgram = "cfn-lint";
    homepage = "https://github.com/aws-cloudformation/cfn-lint";
    changelog = "https://github.com/aws-cloudformation/cfn-lint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
