{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, mock
, parameterized
, pytestCheckHook
, pythonOlder
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "aws-sam-translator";
  version = "1.42.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "v${version}";
    sha256 = "sha256-pjcRsmxPL4lbgDopW+wKQRkRcqebLPTd95JTL8PiWtc=";
  };

  propagatedBuildInputs = [
    boto3
    jsonschema
    six
  ];

  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "jsonschema~=3.2" "jsonschema>=3.2"
    substituteInPlace pytest.ini \
      --replace " --cov samtranslator --cov-report term-missing --cov-fail-under 95" ""
  '';

  checkInputs = [
    mock
    parameterized
    pytestCheckHook
    pyyaml
  ];

  disabledTests = [
    # AssertionError: Expected 7 errors, found 9:
    "test_errors_13_error_definitionuri"
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
