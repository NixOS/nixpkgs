{
  lib,
  boto3,
  buildPythonPackage,
  click,
  click-default-group,
  fetchFromGitHub,
  hypothesis,
  moto,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "s3-credentials";
  version = "0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "s3-credentials";
    tag = version;
    hash = "sha256-zDolFoil/oTmvFDGVF+cLTgCpfigvvEW2UuVdIN2pYM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boto3
    click
    click-default-group
  ];

  nativeCheckInputs = [
    hypothesis
    moto
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "s3_credentials" ];

  disabledTests = [
    # AssertionError: assert 'directory/th...ory/...
    "test_put_objects"
  ];

  meta = {
    description = "Python CLI utility for creating credentials for accessing S3 buckets";
    homepage = "https://github.com/simonw/s3-credentials";
    changelog = "https://github.com/simonw/s3-credentials/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ techknowlogick ];
    mainProgram = "s3-credentials";
  };
}
