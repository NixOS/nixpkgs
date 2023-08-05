{ beautifulsoup4
, boto3
, buildPythonPackage
, fetchFromGitHub
, lib
, lxml
, packaging
, pytest-mock
, pytestCheckHook
, pythonOlder
, pytz
, requests
, scramp
}:

buildPythonPackage rec {
  pname = "redshift-connector";
  version = "2.0.911";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-redshift-python-driver";
    rev = "refs/tags/v${version}";
    hash = "sha256-D1LpFGYEpGmkYCAJbYJaQStDnol90mH8X4S6iXg6Nfs=";
  };

  # disable test coverage
  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    boto3
    lxml
    packaging
    pytz
    requests
    scramp
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  # integration tests require a Redshift cluster
  pytestFlagsArray = [ "test/unit" ];

  __darwinAllowLocalNetworking = true; # required for tests

  meta = {
    description = "Redshift interface library";
    homepage = "https://github.com/aws/amazon-redshift-python-driver";
    changelog = "https://github.com/aws/amazon-redshift-python-driver/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
