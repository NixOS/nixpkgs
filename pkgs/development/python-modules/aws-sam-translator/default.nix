{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
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

  meta = with lib; {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/awslabs/serverless-application-model";
    changelog = "https://github.com/aws/serverless-application-model/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
