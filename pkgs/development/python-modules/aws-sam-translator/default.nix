{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, mock
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
  version = "1.55.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-YDqdd4zKInttHDl04kvAgHKtc1vBryW12QfE0wiLU54=";
  };

  propagatedBuildInputs = [
    boto3
    jsonschema
    pydantic
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "jsonschema~=3.2" "jsonschema>=3.2"
    substituteInPlace pytest.ini \
      --replace " --cov samtranslator --cov-report term-missing --cov-fail-under 95" ""
  '';

  nativeCheckInputs = [
    mock
    parameterized
    pytest-env
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    pyyaml
  ];

  disabledTests = [
    # AssertionError: Expected 7 errors, found 9:
    "test_errors_13_error_definitionuri"
  ];

  pytestFlagsArray = [
    # samtranslator.translator.arn_generator.NoRegionFound: AWS Region cannot be found
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sar_success_one_app"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sar_throttling_doesnt_stop_processing"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sleep_between_sar_checks"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_unexpected_sar_error_stops_processing"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_and_on_after_transform_template::test_time_limit_exceeds_between_combined_sar_calls"
    "--deselect tests/unit/test_region_configuration.py::TestRegionConfiguration::test_is_service_supported_positive_4_ec2"
  ];

  pythonImportsCheck = [
    "samtranslator"
  ];

  meta = with lib; {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/awslabs/serverless-application-model";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
