{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jsonschema
, parameterized
, pydantic
, pytest-env
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyyaml
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aws-sam-translator";
  version = "1.74.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
    hash = "sha256-uOfBR0bvLVyBcfSAkSqOx4KjmSYbfktpJlxKjipfj50=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/aws/serverless-application-model/commit/e41b0f02204635a655100b68dd38220af32a2728.patch";
      hash = "sha256-V6KXdXQUr9fvLzxI6sUMrSRnGX5SrAaDygcaQ87FaQ8=";
    })
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov samtranslator --cov-report term-missing --cov-fail-under 95" ""
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

  pythonImportsCheck = [
    "samtranslator"
  ];

  preCheck = ''
    sed -i '2ienv =\n\tAWS_DEFAULT_REGION=us-east-1' pytest.ini
  '';

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

  meta = with lib; {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/awslabs/serverless-application-model";
    changelog = "https://github.com/aws/serverless-application-model/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
