{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, mock
, parameterized
, pyelftools
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "aws-lambda-builders";
  version = "1.23.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "refs/tags/v${version}";
    hash = "sha256-t/fdj0p3Z0J0C1v+TWx5jWNOjdAK2f0sPPkNM3SthXk=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    mock
    parameterized
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
    # Tests which are passing locally but not on Hydra
    "test_copy_dependencies_action_1_multiple_files"
    "test_move_dependencies_action_1_multiple_files"
  ];

  pythonImportsCheck = [
    "aws_lambda_builders"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Tool to compile, build and package AWS Lambda functions";
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
