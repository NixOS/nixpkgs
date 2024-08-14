{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  parameterized,
  pip,
  pyelftools,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "aws-lambda-builders";
  version = "1.50.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "refs/tags/v${version}";
    hash = "sha256-GXpyO+Qd6NP5yxWn1kw34x+P5uyR0rcNlzwivT6eHdE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=read_version()," 'version="${version}",'
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    mock
    parameterized
    pip
    pyelftools
    pytestCheckHook
  ];

  disabledTests = [
    # CLI don't work in the sandbox
    "test_run_hello_workflow"
    # Don't tests integrations
    "TestCustomMakeWorkflow"
    "TestDotnet31"
    "TestDotnet6"
    "TestGoWorkflow"
    "TestJavaGradle"
    "TestJavaMaven"
    "TestNodejsNpmWorkflow"
    "TestNodejsNpmWorkflowWithEsbuild"
    "TestPipRunner"
    "TestPythonPipWorkflow"
    "TestRubyWorkflow"
    "TestRustCargo"
    "test_with_mocks"
    # Tests which are passing locally but not on Hydra
    "test_copy_dependencies_action_1_multiple_files"
    "test_move_dependencies_action_1_multiple_files"
  ];

  disabledTestPaths = [
    # Dotnet binary needed
    "tests/integration/workflows/dotnet_clipackage/test_dotnet.py"
  ];

  pythonImportsCheck = [ "aws_lambda_builders" ];

  meta = with lib; {
    description = "Tool to compile, build and package AWS Lambda functions";
    mainProgram = "lambda-builders";
    homepage = "https://github.com/awslabs/aws-lambda-builders";
    changelog = "https://github.com/aws/aws-lambda-builders/releases/tag/v${version}";
    longDescription = ''
      Lambda Builders is a Python library to compile, build and package
      AWS Lambda functions for several runtimes & frameworks.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
