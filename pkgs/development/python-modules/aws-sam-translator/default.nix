{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, mock
, parameterized
, pytest-env
, pytestCheckHook
, pythonOlder
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "aws-sam-translator";
  version = "1.47.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-FYEJ+mMxb8+OXUVeyLbAqOnujNi/wNhvAl4Lh4ZeE0I=";
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
    pytest-env
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
