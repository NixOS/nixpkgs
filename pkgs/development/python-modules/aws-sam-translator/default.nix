{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, jsonschema
=======
, fetchpatch
, jsonschema
, mock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "1.73.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.60.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aws";
    repo = "serverless-application-model";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-rj+q/06gIvPYTJP/EH9ZrP0Sp4J3K1aCRyNkgpphWP4=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov samtranslator --cov-report term-missing --cov-fail-under 95" ""
  '';

=======
    hash = "sha256-exVB1STX8OsFnQ0pzSuR3O/FrvG2GR5MdZa8tZ9IJvI=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    boto3
    jsonschema
    pydantic
    typing-extensions
  ];

<<<<<<< HEAD
=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    parameterized
    pytest-env
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    pyyaml
  ];

<<<<<<< HEAD
=======
  doCheck = false; # tests fail in weird ways

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "samtranslator"
  ];

<<<<<<< HEAD
  preCheck = ''
    sed -i '2ienv =\n\tAWS_DEFAULT_REGION=us-east-1' pytest.ini
  '';

  meta = with lib; {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/awslabs/serverless-application-model";
    changelog = "https://github.com/aws/serverless-application-model/releases/tag/v${version}";
=======
  meta = with lib; {
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    homepage = "https://github.com/awslabs/serverless-application-model";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
