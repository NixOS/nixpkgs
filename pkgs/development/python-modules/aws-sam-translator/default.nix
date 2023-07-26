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
  version = "1.73.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
    hash = "sha256-rj+q/06gIvPYTJP/EH9ZrP0Sp4J3K1aCRyNkgpphWP4=";
  };

  propagatedBuildInputs = [
    boto3
    jsonschema
    pydantic
    typing-extensions
  ];

  preCheck = ''
    sed -i '2ienv =\n\tAWS_DEFAULT_REGION=us-east-1' pytest.ini
    substituteInPlace pytest.ini \
      --replace " --cov samtranslator --cov-report term-missing --cov-fail-under 95" ""
  '';

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

  meta = with lib; {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/aws/serverless-application-model";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
