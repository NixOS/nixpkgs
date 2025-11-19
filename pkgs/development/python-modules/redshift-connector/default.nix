{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  beautifulsoup4,
  boto3,
  botocore,
  lxml,
  packaging,
  pytz,
  requests,
  scramp,

  # test
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "redshift-connector";
  version = "2.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-redshift-python-driver";
    tag = "v${version}";
    hash = "sha256-x0VhICEtZZz4Q7btCl7nP0D+YHPIKqbEUWnrEekJpt0=";
  };

  # remove addops as they add test directory and coverage parameters to pytest
  postPatch = ''
    substituteInPlace setup.cfg --replace 'addopts =' 'no-opts ='
  '';

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    boto3
    botocore
    lxml
    packaging
    pytz
    requests
    scramp
  ];

  pythonRelaxDeps = [ "lxml" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  # integration tests require a Redshift cluster
  enabledTestPaths = [ "test/unit" ];

  disabledTests = [
    # AttributeError: 'itertools._tee' object has no attribute 'status_code'
    # This is due to a broken pytest_mock.
    # TODO Remove once pytest-mock 3.15.1 lands.
    "test_form_based_authentication_uses_user_set_login_to_rp"
    "test_form_based_authentication_payload_is_correct"
    "test_form_based_authentication_login_fails_should_fail"
    "test_azure_oauth_based_authentication_payload_is_correct"
    "test_okta_authentication_payload_is_correct"
    "test_set_cluster_identifier_calls_describe_custom_domain_associations"
  ];

  __darwinAllowLocalNetworking = true; # required for tests

  meta = {
    description = "Redshift interface library";
    homepage = "https://github.com/aws/amazon-redshift-python-driver";
    changelog = "https://github.com/aws/amazon-redshift-python-driver/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
