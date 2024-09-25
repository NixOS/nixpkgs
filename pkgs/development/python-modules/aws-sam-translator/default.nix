{
  lib,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  parameterized,
  pydantic,
  pytest-env,
  pytest-rerunfailures,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aws-sam-translator";
  version = "1.89.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
    hash = "sha256-wqM3n99lD0s/E9nd55q19Us31XgFtU/bBYJR1HTnnvk=";
  };

  postPatch = ''
    # don't try to use --cov or fail on new warnings
    rm pytest.ini
  '';

  propagatedBuildInputs = [
    boto3
    jsonschema
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [
    parameterized
    pytest-env
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    pyyaml
  ];

  preCheck = ''
    export AWS_DEFAULT_REGION=us-east-1
  '';

  pytestFlagsArray = [
    "tests"
    ''-m "not slow"''
  ];

  disabledTests = [
    # urllib3 2.0 compat
    "test_plugin_accepts_different_sar_client"
    "test_plugin_accepts_flags"
    "test_plugin_accepts_parameters"
    "test_plugin_default_values"
    "test_plugin_invalid_configuration_raises_exception"
    "test_plugin_must_setup_correct_name"
    "test_must_process_applications"
    "test_must_process_applications_validate"
    "test_process_invalid_applications"
    "test_process_invalid_applications_validate"
    "test_resolve_intrinsics"
    "test_sar_service_calls"
    "test_sar_success_one_app"
    "test_sar_throttling_doesnt_stop_processing"
    "test_sleep_between_sar_checks"
    "test_unexpected_sar_error_stops_processing"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "samtranslator" ];

  meta = with lib; {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/aws/serverless-application-model";
    changelog = "https://github.com/aws/serverless-application-model/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
