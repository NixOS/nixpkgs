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
  version = "1.60.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
    hash = "sha256-exVB1STX8OsFnQ0pzSuR3O/FrvG2GR5MdZa8tZ9IJvI=";
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
    parameterized
    pytest-env
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    pyyaml
  ];

  doCheck = false; # tests fail in weird ways

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
