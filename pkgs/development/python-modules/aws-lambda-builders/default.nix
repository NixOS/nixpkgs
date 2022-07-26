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
  version = "1.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "refs/tags/v${version}";
    hash = "sha256-yAqGVZnnragi3+jaAGnkYNH/XtpH3bojXHmPCrANgJU=";
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
    longDescription = ''
      Lambda Builders is a Python library to compile, build and package
      AWS Lambda functions for several runtimes & frameworks.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
