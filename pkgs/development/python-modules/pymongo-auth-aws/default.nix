{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  hatchling,
  hatch-requirements-txt,

  # dependencies
  boto3,
  botocore,

  # test dependencies
  pymongo,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymongo-auth-aws";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "pymongo-auth-aws";
    tag = finalAttrs.version;
    hash = "sha256-532Srsaa1wlFoK4BHiTTl8CtdJ3MBnEm7Apqg05vv0w=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [
    boto3
    botocore
  ];

  pythonImportsCheck = [ "pymongo_auth_aws" ];

  nativeCheckInputs = [
    pymongo
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/mongodb/pymongo-auth-aws/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "MONGODB-AWS authentication mechanism for PyMongo";
    homepage = "https://github.com/mongodb/pymongo-auth-aws";
    license = lib.licenses.asl20;
  };
})
