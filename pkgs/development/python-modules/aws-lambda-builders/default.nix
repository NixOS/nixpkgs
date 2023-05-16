<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, parameterized
, pip
=======
{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, mock
, parameterized
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyelftools
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "aws-lambda-builders";
<<<<<<< HEAD
  version = "1.37.0";
=======
  version = "1.28.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ukHDrxx+Jxlp/Ypg1ltz7WN07X16spNdC7YygJhTBJo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=read_version()," 'version="${version}",'
  '';

=======
    hash = "sha256-JSN51zwIh9N/Id3fhBXjmwGa2tLK/LoyPlHPl2rbVU4=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    six
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    mock
    parameterized
    pip
=======
  patches = [
    # This patch can be removed once https://github.com/aws/aws-lambda-builders/pull/475 has been merged.
    (fetchpatch {
      name = "setuptools-66-support";
      url = "https://patch-diff.githubusercontent.com/raw/aws/aws-lambda-builders/pull/475.patch";
      sha256 = "sha256-EkYQ6DNzbSnvkOads0GFwpGzeuBoLVU42THlSZNOHMc=";
    })
  ];

  nativeCheckInputs = [
    mock
    parameterized
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    # Tests which are passing locally but not on Hydra
    "test_copy_dependencies_action_1_multiple_files"
    "test_move_dependencies_action_1_multiple_files"
  ];

  pythonImportsCheck = [
    "aws_lambda_builders"
  ];

  meta = with lib; {
<<<<<<< HEAD
=======
    broken = (stdenv.isLinux && stdenv.isAarch64);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
