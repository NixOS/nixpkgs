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
  version = "2.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-redshift-python-driver";
    tag = "v${version}";
    hash = "sha256-q8TQYiPmm3w9Bh4+gvVW5XAa4FZ3+/MZqZL0RCgl77E=";
  };

  # remove addops as they add test directory and coverage parameters to pytest
  postPatch = ''
    substituteInPlace setup.cfg --replace 'addopts =' 'no-opts ='
  '';

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    boto3
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

  __darwinAllowLocalNetworking = true; # required for tests

  meta = {
    description = "Redshift interface library";
    homepage = "https://github.com/aws/amazon-redshift-python-driver";
    changelog = "https://github.com/aws/amazon-redshift-python-driver/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
