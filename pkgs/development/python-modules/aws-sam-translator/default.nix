{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "1.58.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
    hash = "sha256-GFHxSGcJeeGMq4e+iD1+paYBKV72tStxHJgefdZSGiI=";
  };

  propagatedBuildInputs = [
    boto3
    jsonschema
    pydantic
    typing-extensions
  ];

  patches = [
    (fetchpatch {
      # relax typing-extenions dependency
      url = "https://github.com/aws/serverless-application-model/commit/d1c26f7ad9510a238ba570d511d5807a81379d0a.patch";
      hash = "sha256-nh6MtRgi0RrC8xLkLbU6/Ec0kYtxIG/fgjn/KLiAM0E=";
    })
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
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_and_on_after_transform_template::test_time_limit_exceeds_between_combined_sar_calls"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sar_success_one_app"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sar_throttling_doesnt_stop_processing"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sleep_between_sar_checks"
    "--deselect tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_unexpected_sar_error_stops_processing"
    "--deselect tests/model/eventsources/test_msk_event_source.py::MSKEventSource::test_get_policy_arn"
    "--deselect tests/swagger/test_swagger.py::TestSwaggerEditor_add_lambda_integration::test_must_add_credentials_to_the_integration"
    "--deselect tests/swagger/test_swagger.py::TestSwaggerEditor_add_lambda_integration::test_must_add_credentials_to_the_integration_overrides"
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
